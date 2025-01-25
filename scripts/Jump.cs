#nullable enable

using Godot;

public partial class Jump : State
{
    [Export]
    public State Fall { get; set; }

    [Export]
    public State DoubleJump { get; set; }

    private double JumpPressedTime = 0;

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);

        var velocity = Parent.Velocity;
        velocity.Y =
            -2 * Parent.ProjectileParameters.JumpHeight / Parent.ProjectileParameters.JumpTime;

        Parent.Velocity = velocity;

        JumpPressedTime = 0;
    }

    public override State? GetNextState()
    {
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
        var maximumVelocity =
            Parent.ProjectileParameters.JumpMaxDistance
            / (Parent.ProjectileParameters.JumpTime + Parent.ProjectileParameters.FallTime);
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
                Parent.ProjectileParameters.JumpHeight,
                Parent.ProjectileParameters.JumpTime
            )
        );
    }
}
