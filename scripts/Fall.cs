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
    public State Idle { get; set; }

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
        }

        Compute(delta);
    }

    private void Compute(float delta)
    {
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

        var gravity =
            2
            * Parent.ProjectileParameters.JumpHeight
            / (Parent.ProjectileParameters.FallTime * Parent.ProjectileParameters.FallTime);

        var velocity = Parent.Velocity;

        var maximumVelocity =
            Parent.ProjectileParameters.JumpMaxDistance
            / (Parent.ProjectileParameters.JumpTime + Parent.ProjectileParameters.FallTime);

        var direction = Parent.MovementController.GetDirection();
        FlipSprite(direction);

        velocity.X = StateUtils.ComputeLateralVelocity(
            delta,
            velocity.X,
            direction,
            maximumVelocity,
            Parent.ProjectileParameters.AccelerationTime,
            Parent.ProjectileParameters.DecelerationTime
        );

        velocity.Y += gravity * delta;

        Parent.Velocity = velocity;

        Parent.MoveAndSlide();
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override State? HandlePhysics(float delta)
    {
        if (Parent.MovementController.WantsToJump() && CoyoteJumpRemainingFrames > 0)
        {
            return Jump;
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

        Compute(delta);

        return null;
    }
}
