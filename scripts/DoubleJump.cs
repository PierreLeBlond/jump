#nullable enable

using Godot;

public partial class DoubleJump : State
{
    [Export]
    public State Fall { get; set; }

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);

        var velocity = Parent.Velocity;
        velocity.Y =
            -2
            * Parent.ProjectileParameters.DoubleJumpHeight
            / Parent.ProjectileParameters.DoubleJumpTime;

        Parent.Velocity = velocity;
    }

    public override State? GetNextState()
    {
        if (Parent.Velocity.Y > 0)
        {
            return Fall;
        }

        return null;
    }

    public override Vector2 GetVelocity(float delta)
    {
        var maximumVelocity =
            Parent.ProjectileParameters.DoubleJumpMaxDistance
            / (Parent.ProjectileParameters.DoubleJumpTime + Parent.ProjectileParameters.FallTime);
        return new Vector2(
            GetLateralVelocity(
                delta,
                Parent.Velocity.X,
                maximumVelocity,
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
