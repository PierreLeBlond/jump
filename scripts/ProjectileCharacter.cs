using Godot;

public partial class ProjectileCharacter : CharacterBody2D
{
    [Export]
    public StateMachine StateMachine { get; set; }

    [Export]
    public MovementController MovementController { get; set; }

    [Export]
    public ProjectileParameters ProjectileParameters { get; set; }

    public override void _Ready()
    {
        StateMachine.Init(this);
    }

    public override void _PhysicsProcess(double delta)
    {
        StateMachine.HandlePhysics((float)delta);
    }
}
