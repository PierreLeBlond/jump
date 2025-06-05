using Godot;

public partial class StateMachine : Node
{
    [Export]
    public State InitialState;

    [Export]
    public Label StateLabel;

    private ProjectileCharacter Parent;
    private State CurrentState;

    public void Init(ProjectileCharacter parent)
    {
        Parent = parent;
        foreach (State state in GetChildren())
        {
            state.Init(Parent);
        }
    }

    private void ChangeState(State newState, float delta)
    {
        newState.Exit();

        var previousState = CurrentState;
        CurrentState = newState;

        StateLabel.Text = CurrentState.Label;

        CurrentState.Enter(previousState, delta);
    }

    public override void _Ready()
    {
        CurrentState = InitialState;
    }

    public void HandlePhysics(float delta)
    {
        var newState = CurrentState.GetNextState(delta);

        if (newState != null)
        {
            ChangeState(newState, (float)delta);
        }

        CurrentState.Update(delta);

        var velocity = CurrentState.GetVelocity((float)delta);
        Parent.Velocity = velocity;

        Parent.MoveAndSlide();

        CurrentState.UpdateSprite();
    }
}
