#nullable enable

using Godot;

public partial class Fall : State
{
    private int BufferedJumpRemainingFrames = 0;

    private int CoyoteJumpRemainingFrames = 0;

    [Export]
    public State Run { get; set; }

    [Export]
    public State Jump { get; set; }

    [Export]
    public State DoubleJump { get; set; }

    [Export]
    public State WallJump { get; set; }

    [Export]
    public State Idle { get; set; }

    private int DoubleJumpCount = 0;

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);
        if (previousState.Label == "Run")
        {
            CoyoteJumpRemainingFrames = Parent.ProjectileParameters.CoyoteJumpFrames;
        }
        else
        {
            CoyoteJumpRemainingFrames = 0;
            MaximumLateralVelocity = previousState.MaximumLateralVelocity;
        }

        if (previousState.Label == "DoubleJump")
        {
            DoubleJumpCount--;
        }
        else
        {
            DoubleJumpCount = Parent.ProjectileParameters.MaxDoubleJumps;
        }
    }

    public override State? GetNextState(float delta)
    {
        if (Parent.MovementController.WantsToJump() && IsOnWall()) {
            return WallJump;
        }

        if (Parent.MovementController.WantsToJump() && CoyoteJumpRemainingFrames > 0)
        {
            return Jump;
        }

        if (Parent.MovementController.WantsToJump() && DoubleJumpCount > 0)
        {
            return DoubleJump;
        }

        if (Parent.IsOnFloor() && BufferedJumpRemainingFrames > 0)
        {
            return Jump;
        }

        if (Parent.IsOnFloor() && Parent.MovementController.GetDirection() != 0)
        {
            return Run;
        }

        if (Parent.IsOnFloor())
        {
            return Idle;
        }

        return null;
    }

    public override void Update(float delta)
    {
        base.Update(delta);

        if (CoyoteJumpRemainingFrames > 0)
        {
            CoyoteJumpRemainingFrames--;
        }

        if (BufferedJumpRemainingFrames > 0)
        {
            BufferedJumpRemainingFrames--;
        }

        if (Parent.MovementController.WantsToJump())
        {
            BufferedJumpRemainingFrames = Parent.ProjectileParameters.BufferedJumpFrames;
        }
    }

    public override Vector2 GetVelocity(float delta)
    {
        return new Vector2(
            GetLateralVelocity(
                delta,
                Parent.Velocity.X,
                MaximumLateralVelocity,
                Parent.ProjectileParameters.AirAccelerationTime,
                Parent.ProjectileParameters.AirDecelerationTime
            ),
            GetVerticalVelocity(
                delta,
                Parent.Velocity.Y,
                Parent.ProjectileParameters.JumpHeight,
                Parent.ProjectileParameters.FallTime
            )
        );
    }
}
