using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;
using System.Text.RegularExpressions;

public abstract class CustomMaterialEditor : MaterialEditor
{
	public class FeatureToggle
	{
		// The name the toggle will have in the inspector.
		public string InspectorName;
		// We will look for properties that contain this word, and hide them if we're not enabled.
		public string InspectorPropertyHideTag;
		// The keyword that the shader uses when this feature is enabled or disabled.
		public string ShaderKeywordEnabled;
		public string ShaderKeywordDisabled;
		// The current state of this feature.
		public bool Enabled;
		
		public FeatureToggle(string InspectorName, string InspectorPropertyHideTag, string ShaderKeywordEnabled, string ShaderKeywordDisabled)
		{
			this.InspectorName = InspectorName;
			this.InspectorPropertyHideTag = InspectorPropertyHideTag;
			this.ShaderKeywordEnabled = ShaderKeywordEnabled;
			this.ShaderKeywordDisabled = ShaderKeywordDisabled;
			this.Enabled = false;
		}
	}
	
	// A list of all the toggles that we have in this material editor.
	protected List<FeatureToggle> Toggles = new List<FeatureToggle>();
	// This function will be implemented in derived classes, and used to populate the list of toggles.
	protected abstract void CreateToggleList(); 

	protected Material targetMat;
	protected string[] oldKeyWords;

	public override void OnInspectorGUI ()
	{
		// if we are not visible... return
		if (!isVisible)
			return;
		
		// Get the current keywords from the material
		targetMat = target as Material;
		oldKeyWords = targetMat.shaderKeywords;
		
		// Populate our list of toggles
		//Toggles.Clear();
		Toggles = new List<FeatureToggle>();
		CreateToggleList();
		
		// Update each toggle to enabled if it's enabled keyword is present. If it's enabled keyword is missing, we assume it's disabled.
		for(int i = 0; i < Toggles.Count; i++)
		{
			Toggles[i].Enabled = oldKeyWords.Contains (Toggles[i].ShaderKeywordEnabled);
		}
		
		// Begin listening for changes in GUI, so we don't waste time re-applying settings that haven't changed.
		EditorGUI.BeginChangeCheck();
		
		serializedObject.Update ();
		var theShader = serializedObject.FindProperty ("m_Shader");
		if (isVisible && !theShader.hasMultipleDifferentValues && theShader.objectReferenceValue != null)
		{
			float controlSize = 64;
			//EditorGUIUtility.labelWidth = Screen.width - controlSize - 20;
			//EditorGUIUtility.labelWidth = controlSize;
			EditorGUIUtility.fieldWidth = controlSize;

			Shader shader = theShader.objectReferenceValue as Shader;
			
			EditorGUI.BeginChangeCheck();
			
			// Draw Non-toggleable values
			for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
			{
				ShaderPropertyImpl(shader, i, null);
			}
			// Draw toggles, then their values.
			for (int s = 0; s < Toggles.Count; s++)
			{
				EditorGUILayout.Separator();
				Toggles[s].Enabled = EditorGUILayout.BeginToggleGroup(Toggles[s].InspectorName, Toggles[s].Enabled);
				
				if (Toggles[s].Enabled)
				{
					for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
					{
						ShaderPropertyImpl(shader, i, Toggles[s]);
					}
				}
				EditorGUILayout.EndToggleGroup();
			}
			
			if (EditorGUI.EndChangeCheck())
				PropertiesChanged ();
		}
		
		// If changes have been made, then apply them.
		if (EditorGUI.EndChangeCheck())
		{
			// New list of key words.
			List<string> newKeyWords = new List<string>();
			
			// If true, add the enabled keyword (ending with _ON), if false, add the disabled keyword(ending with _OFF).
			for(int i = 0; i < Toggles.Count; i++)
			{
				newKeyWords.Add(Toggles[i].Enabled ? Toggles[i].ShaderKeywordEnabled : Toggles[i].ShaderKeywordDisabled);
			}
			
			// Send the new list of keywords to the material, this will define what version of the shader to use.
			targetMat.shaderKeywords = newKeyWords.ToArray ();
			EditorUtility.SetDirty (targetMat);
		}
	}
	
	// This runs once for every property in our shader.
	private void ShaderPropertyImpl(Shader shader, int propertyIndex, FeatureToggle currentToggle)
	{
		string propertyDescription = ShaderUtil.GetPropertyDescription(shader, propertyIndex);
		
		// If current toggle is null, we only want to show properties that aren't already "owned" by a toggle,
		// so if it is owned by another toggle, then return.
		if (currentToggle == null)
		{
			for (int i = 0; i < Toggles.Count; i++)
			{
				if (Regex.IsMatch(propertyDescription, Toggles[i].InspectorPropertyHideTag , RegexOptions.IgnoreCase))
				{
					return; 
				}           
			}       
		}      
		// Only draw if we the current property is owned by the current toggle. 
		else if (!Regex.IsMatch(propertyDescription, currentToggle.InspectorPropertyHideTag , RegexOptions.IgnoreCase))
		{          
			return; 
		}       
		// If we've gotten to this point, draw the shader property regulairly.
		//ShaderProperty(shader,propertyIndex);
		Object[] temptarget = new Object[1];
		temptarget[0] = target;
		MaterialProperty prop = GetMaterialProperty(temptarget, propertyIndex);
		ShaderProperty(prop,propertyDescription);

	}
}
