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
        var state = CurrentState.HandlePhysics((float)delta);

        if (state == null)
        {
            return;
        }

        ChangeState(state, (float)delta);
    }
}
