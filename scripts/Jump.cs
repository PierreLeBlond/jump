#nullable enable

using Godot;

public partial class Jump : State
{
    [Export]
    public State Fall { get; set; }

    private double JumpPressedTime = 0;

    private void Compute(float delta)
    {
        JumpPressedTime += delta;

        var gravity =
            2
            * Parent.ProjectileParameters.JumpHeight
            / (Parent.ProjectileParameters.JumpTime * Parent.ProjectileParameters.JumpTime);

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

        velocity.Y += gravity * (float)delta;

        Parent.Velocity = velocity;

        Parent.MoveAndSlide();
    }

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);

        var velocity = Parent.Velocity;
        velocity.Y =
            -2 * Parent.ProjectileParameters.JumpHeight / Parent.ProjectileParameters.JumpTime;

        Parent.Velocity = velocity;

        JumpPressedTime = 0;

        Compute(delta);
    }

    public override State? HandlePhysics(float delta)
    {
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

        Compute(delta);

        return null;
    }
}
