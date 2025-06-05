using Godot;

public partial class ProjectileCharacter : CharacterBody2D
{
    [Export]
    public CornerCorrector CornerCorrector { get; set; }

    [Export]
    public StateMachine StateMachine { get; set; }

    [Export]
    public MovementController MovementController { get; set; }

    [Export]
    public ProjectileParameters ProjectileParameters { get; set; }

    [Export]
    public RayCast2D LeftRayCast2D { get; set; }

    [Export]
    public RayCast2D RightRayCast2D { get; set; }

    [Export]
    public RayCast2D OuterLeftCeilingRayCast2D { get; set; }

    [Export]
    public RayCast2D InnerLeftCeilingRayCast2D { get; set; }

    [Export]
    public RayCast2D OuterRightCeilingRayCast2D { get; set; }

    [Export]
    public RayCast2D InnerRightCeilingRayCast2D { get; set; }

    public override void _Ready()
    {
        CornerCorrector.Init(this);
        StateMachine.Init(this);
    }

    public override void _PhysicsProcess(double delta)
    {
        CornerCorrector.ApplyCornerCorrection();
        StateMachine.HandlePhysics((float)delta);
    }
}
