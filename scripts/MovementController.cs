using Godot;

public partial class MovementController : Node
{
    public virtual int GetDirection()
    {
        return 0;
    }

    public virtual bool WantsToJump()
    {
        return false;
    }

    public virtual bool WantsToRun()
    {
        return false;
    }

    public virtual bool CancelJump()
    {
        return false;
    }
}
