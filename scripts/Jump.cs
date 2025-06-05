#nullable enable

using Godot;

public partial class Jump : State
{
    [Export]
    public State Fall { get; set; }

    [Export]
    public State DoubleJump { get; set; }

    [Export]
    public State WallJump { get; set; }

    private double JumpPressedTime = 0;

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);

        var velocity = Parent.Velocity;
        velocity.Y =
            -2 * Parent.ProjectileParameters.JumpHeight / Parent.ProjectileParameters.JumpTime;

        Parent.Velocity = velocity;

        var runFactor = Parent.MovementController.WantsToRun() ? Parent.ProjectileParameters.RunFactor : 1;

        // We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
        MaximumLateralVelocity = (Mathf.Abs(Parent.Velocity.X) + Parent.ProjectileParameters.MaximumVelocity * runFactor) / 2 * (Parent.ProjectileParameters.JumpTime + Parent.ProjectileParameters.FallTime);

        JumpPressedTime = 0;
    }

    public override State? GetNextState(float delta)
    {
        if (Parent.MovementController.WantsToJump() && IsOnWall()) {
            return WallJump;
        }

        if (Parent.MovementController.WantsToJump())
        {
            return DoubleJump;
        }

        if (Parent.Velocity.Y > 0)
        {
            return Fall;
        }

        if (
            Parent.MovementController.CancelJump()
            && JumpPressedTime > Parent.ProjectileParameters.MinimumJumpPressedTime
            && JumpPressedTime < Parent.ProjectileParameters.MaximumJumpPressedTime
        )
        {
            // TODO: Use a CancelJumpState with a better transition curve
            return Fall;
        }

        return null;
    }

    public override void Update(float delta)
    {
        JumpPressedTime += delta;
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
                Parent.ProjectileParameters.JumpTime
            )
        );
    }
}
