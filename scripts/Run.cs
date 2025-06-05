#nullable enable

using Godot;

public partial class Run : State
{
    [Export]
    public State Fall;

    [Export]
    public State Jump;

    [Export]
    public State Walk;

    [Export]
    public State Idle;

    public override State? GetNextState(float delta)
    {
        if (!Parent.MovementController.WantsToRun())
        {
            return Walk;
        }

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

        return null;
    }

    public override Vector2 GetVelocity(float delta)
    {
        MaximumLateralVelocity = Parent.MovementController.WantsToRun()
            ? Parent.ProjectileParameters.MaximumVelocity * Parent.ProjectileParameters.RunFactor
            : Parent.ProjectileParameters.MaximumVelocity;

        return new Vector2(
            GetLateralVelocity(
                delta,
                Parent.Velocity.X,
                MaximumLateralVelocity,
                Parent.ProjectileParameters.AccelerationTime,
                Parent.ProjectileParameters.DecelerationTime
            ),
            0
        );
    }
}
