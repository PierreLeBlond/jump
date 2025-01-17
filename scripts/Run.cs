#nullable enable

using System.ComponentModel.DataAnnotations;
using Godot;

public partial class Run : State
{
    [Export]
    public State Fall { get; set; }

    [Export]
    public State Jump { get; set; }

    [Export]
    public State Idle { get; set; }

    private void Compute(float delta)
    {
        var maximumVelocity =
            Parent.ProjectileParameters.JumpMaxDistance
            / (Parent.ProjectileParameters.JumpTime + Parent.ProjectileParameters.FallTime);

        var direction = Parent.MovementController.GetDirection();
        FlipSprite(direction);

        var velocity = Parent.Velocity;
        velocity.X = StateUtils.ComputeLateralVelocity(
            delta,
            velocity.X,
            direction,
            maximumVelocity,
            Parent.ProjectileParameters.AccelerationTime,
            Parent.ProjectileParameters.DecelerationTime
        );
        Parent.Velocity = velocity;

        Parent.MoveAndSlide();
    }

    public override void Enter(State previousState, float delta)
    {
        base.Enter(previousState, delta);
        Compute(delta);
    }

    public override State? HandlePhysics(float delta)
    {
        if (Parent.MovementController.WantsToJump())
        {
            return Jump;
        }

        if (!Parent.IsOnFloor())
        {
            return Fall;
        }

        if (Parent.MovementController.GetDirection() == 0 && Parent.Velocity.X == 0)
        {
            return Idle;
        }

        Compute(delta);

        return null;
    }
}
