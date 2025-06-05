using Godot;

public partial class PlayerController : MovementController
{
    public override int GetDirection()
    {
        var direction = 0;

        if (Input.IsActionPressed("move_right"))
        {
            direction++;
        }

        if (Input.IsActionPressed("move_left"))
        {
            direction--;
        }

        return direction;
    }

    public override bool WantsToJump()
    {
        return Input.IsActionJustPressed("jump");
    }

    public override bool WantsToRun()
    {
        return Input.IsActionPressed("run");
    }

    public override bool CancelJump()
    {
        return !Input.IsActionPressed("jump");
    }
}
