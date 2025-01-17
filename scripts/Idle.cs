#nullable enable

using Godot;

public partial class Idle : State
{
    [Export]
    public State Jump { get; set; }

    [Export]
    public State Fall { get; set; }

    [Export]
    public State Run { get; set; }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override State? HandlePhysics(float delta)
    {
        if (!Parent.IsOnFloor())
        {
            return Fall;
        }

        if (Parent.MovementController.WantsToJump())
        {
            return Jump;
        }

        if (Parent.MovementController.GetDirection() != 0)
        {
            return Run;
        }

        return null;
    }
}
