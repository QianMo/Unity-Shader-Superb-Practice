using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class Shader_softrim_dissolve : CustomMaterialEditor
{
	protected override void CreateToggleList()
	{
		Toggles.Add(new FeatureToggle("Soft Dissolve Enabled","soft_dissolve","SOFTDISSOLVE_ON","SOFTDISSOLVE_OFF"));
		Toggles.Add(new FeatureToggle("Opacity Slider Enabled","opacity","OPACITYSLIDER_ON","OPACITYSLIDER_OFF"));

		Toggles.Add(new FeatureToggle("Soft Rim Enabled","rim","SOFTRIM_ON","SOFTRIM_OFF"));
		Toggles.Add(new FeatureToggle("For_Stretch_Billboard Enabled","stretch","STRETCH_ON","STRETCH_OFF"));

		Toggles.Add(new FeatureToggle("Edge Enabled","edge","EDGE_ON","EDGE_OFF"));
	}
}