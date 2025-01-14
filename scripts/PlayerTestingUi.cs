using Godot;

public partial class PlayerTestingUi : Control
{
    [Export]
    public Slider JumpFactorSlider;

    [Signal]
    public delegate void JumpFactorChangedEventHandler(double value);

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        JumpFactorSlider.ValueChanged += (double value) =>
        {
            EmitSignal(SignalName.JumpFactorChanged, value);
        };
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta) { }
}
