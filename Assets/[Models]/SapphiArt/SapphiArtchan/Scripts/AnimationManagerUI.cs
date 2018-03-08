using UnityEngine;
using System.Collections;

public class AnimationManagerUI : MonoBehaviour {

    internal string _Animation = null;
    internal string _EyesChangeType = null;
    internal string _EyebrowsChangeType = null;
    internal string _MouthChangeType = null;
    internal string _GeneralChangeType = null;
    internal float _FacialValue = 0.0f;
    internal bool _FacialValueBool = false;

    public void SetAnimation_Idle()
    {
        _Animation = "idle";
    }

    public void SetAnimation_Run()
    {
        _Animation = "running";
    }

    public void SetAnimation_Walk()
    {
        _Animation = "walk";
    }

    public void SetAnimation_Jump()
    {
        _Animation = "jump";
    }


    public void SetAnimation_WinPose()
    {
        _Animation = "winpose";
    }

    public void SetAnimation_KO()
    {
        _Animation = "ko_big";
    }

    public void SetAnimation_Damage()
    {
        _Animation = "damage";
    }

    public void SetAnimation_Hit01()
    {
        _Animation = "hit01";
    }

    public void SetAnimation_Hit02()
    {
        _Animation = "hit02";
    }

    public void SetAnimation_Hit03()
    {
        _Animation = "hit03";
    }


    public void SetFacial_Eye_L_Happy(float newFacialValue)
    {
        _GeneralChangeType = "eyes";
        _EyesChangeType = "happyL";
        _FacialValue = newFacialValue*100;
    }

    public void SetFacial_Eye_R_Happy(float newFacialValue)
    {
        _GeneralChangeType = "eyes";
        _EyesChangeType = "happyR";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eye_L_Closed(float newFacialValue)
    {
        _GeneralChangeType = "eyes";
        _EyesChangeType = "closedL";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eye_R_Closed(float newFacialValue)
    {
        _GeneralChangeType = "eyes";
        _EyesChangeType = "closedR";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eye_L_Wide(float newFacialValue)
    {
        _GeneralChangeType = "eyes";
        _EyesChangeType = "wideL";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eye_R_Wide(float newFacialValue)
    {
        _GeneralChangeType = "eyes";
        _EyesChangeType = "wideR";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Mouth_Sad(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "sad";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Mouth_Puff(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "puff";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Mouth_Smile(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "smile";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eyebrow_L_Up(float newFacialValue)
    {
        _GeneralChangeType = "eyebrows";
        _EyebrowsChangeType = "upL";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eyebrow_R_Up(float newFacialValue)
    {
        _GeneralChangeType = "eyebrows";
        _EyebrowsChangeType = "upR";
        _FacialValue = newFacialValue * 100;
    }


    public void SetFacial_Eyebrow_L_Anger(float newFacialValue)
    {
        _GeneralChangeType = "eyebrows";
        _EyebrowsChangeType = "angerL";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eyebrow_R_Anger(float newFacialValue)
    {
        _GeneralChangeType = "eyebrows";
        _EyebrowsChangeType = "angerR";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eyebrow_L_Sad(float newFacialValue)
    {
        _GeneralChangeType = "eyebrows";
        _EyebrowsChangeType = "sadL";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Eyebrow_R_Sad(float newFacialValue)
    {
        _GeneralChangeType = "eyebrows";
        _EyebrowsChangeType = "sadR";
        _FacialValue = newFacialValue * 100;
    }


    public void SetFacial_Mouth_E(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthE";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_Mouth_O(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthO";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_MouthJawOpen(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthJawOpen";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_MouthExtra01(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthExtra01";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_MouthExtra02(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthExtra02";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_MouthExtra03(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthExtra03";
        _FacialValue = newFacialValue * 100;
    }


    public void SetFacial_MouthBottomTeeth(float newFacialValue)
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthBottomTeeth";
        _FacialValue = newFacialValue * 100;
    }

    public void SetFacial_MouthTopTeeth()
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthTopTeeth";
        if(_FacialValueBool == false)
            _FacialValueBool = true;
        else
            _FacialValueBool = false;
    }

    public void SetFacial_MouthTongue()
    {
        _GeneralChangeType = "mouth";
        _MouthChangeType = "mouthTongue";
        if (_FacialValueBool == false)
            _FacialValueBool = true;
        else
            _FacialValueBool = false;
    }
}
