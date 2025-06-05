#nullable enable

using Godot;

public partial class DoubleJump : State
{
    [Export]
    public State Fall { get; set; }

    [Export]
    public State WallJump { get; set; }

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);

        var velocity = Parent.Velocity;
        velocity.Y =
            -2
            * Parent.ProjectileParameters.DoubleJumpHeight
            / Parent.ProjectileParameters.DoubleJumpTime;

        Parent.Velocity = velocity;

        // We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
        MaximumLateralVelocity = (Mathf.Abs(Parent.Velocity.X) + Parent.ProjectileParameters.DoubleJumpMaximumVelocity) / 2 * (Parent.ProjectileParameters.DoubleJumpTime + Parent.ProjectileParameters.FallTime);
    }

    public override State? GetNextState(float delta)
    {
        if (Parent.MovementController.WantsToJump() && IsOnWall()) {
            return WallJump;
        }

        if (Parent.Velocity.Y > 0)
        {
            return Fall;
        }

        return null;
    }

    public override Vector2 GetVelocity(float delta)
    {
        return new Vector2(
            GetLateralVelocity(
                delta,
                Parent.Velocity.X,
                MaximumLateralVelocity,
                Parent.ProjectileParameters.AccelerationTime,
                Parent.ProjectileParameters.DecelerationTime
            ),
            GetVerticalVelocity(
                delta,
                Parent.Velocity.Y,
                Parent.ProjectileParameters.DoubleJumpHeight,
                Parent.ProjectileParameters.DoubleJumpTime
            )
        );
    }
}
