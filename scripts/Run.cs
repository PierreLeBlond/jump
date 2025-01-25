#nullable enable

using Godot;

public partial class Run : State
{
    [Export]
    public State Fall;

    [Export]
    public State Jump;

    [Export]
    public State Idle;

    public override State? GetNextState()
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

        return null;
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
            0
        );
    }
}
