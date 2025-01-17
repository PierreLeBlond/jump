using Godot;

public partial class PlayerTestingUi : Control
{
    [Export]
    public ProjectileCharacter Player;

    [Export]
    public TestingSlider JumpHeightSlider;

    public override void _Ready()
    {
        JumpHeightSlider.Init(Player.ProjectileParameters.JumpHeight);
        JumpHeightSlider.ValueChanged += (float value) =>
        {
            Player.ProjectileParameters.JumpHeight = (int)value;
        };
    }
}
