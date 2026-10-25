package net.bigpoint.darkorbit.fui.builder.xml.creators.skins
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons.ButtonSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons.CheckboxSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons.FadableButtonSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons.RadioButtonSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons.ToggleButtonSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.text.InputSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.text.LabelSkinCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.text.MarqueeLabelSkinCreator;
   
   public class SkinCreator extends AbstractCreator
   {
      
      protected static var CLASSNAME_CONTAINER_SKIN:String = "ContainerSkin";
      
      protected static var CLASSNAME_WINDOW_SKIN:String = "WindowSkin";
      
      protected static var CLASSNAME_BASIC_SKIN:String = "BasicSkin";
      
      protected static var CLASSNAME_BASIC_STATE_SKIN:String = "BasicStateSkin";
      
      protected static var CLASSNAME_BUTTON_BITMAP_SKIN:String = "ButtonSkin";
      
      protected static var CLASSNAME_FADEABLE_BUTTON_BITMAP_SKIN:String = "FadableButtonSkin";
      
      protected static var CLASSNAME_TOGGLE_BUTTON_BITMAP_SKIN:String = "ToggleButtonSkin";
      
      protected static const CLASSNAME_FADEABLE_BUTTON_STATE_SKIN:String = "FadableStateButtonSkin";
      
      protected static var CLASSNAME_CHECKBOX_BITMAP_SKIN:String = "CheckBoxSkin";
      
      protected static var CLASSNAME_RADIOBUTTON_BITMAP_SKIN:String = "RadioButtonSkin";
      
      protected static var CLASSNAME_TEXT_LABEL_SKIN:String = "LabelSkin";
      
      protected static var CLASSNAME_TEXT_MARQUEE_LABEL_SKIN:String = "MarqueeLabelSkin";
      
      protected static var CLASSNAME_TEXT_INPUT_SKIN:String = "InputSkin";
      
      protected static var CLASSNAME_TEXT_RICHTEXT_SKIN:String = "RichTextSkin";
      
      protected static var CLASSNAME_PROGRESS_BAR_SKIN:String = "ProgressBarSkin";
      
      protected static var skinClassnameToInstanceMap:Dictionary = new Dictionary();
      
      public function SkinCreator()
      {
         super();
         initSkinMapping();
      }
      
      protected static function initSkinMapping() : void
      {
         skinClassnameToInstanceMap[CLASSNAME_CONTAINER_SKIN] = new ContainerSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_WINDOW_SKIN] = new ContainerSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_BASIC_SKIN] = new ContainerSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_BASIC_STATE_SKIN] = new ContainerStateSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_BUTTON_BITMAP_SKIN] = new ButtonSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_TOGGLE_BUTTON_BITMAP_SKIN] = new ToggleButtonSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_FADEABLE_BUTTON_BITMAP_SKIN] = new FadableButtonSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_CHECKBOX_BITMAP_SKIN] = new CheckboxSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_RADIOBUTTON_BITMAP_SKIN] = new RadioButtonSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_TEXT_LABEL_SKIN] = new LabelSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_TEXT_MARQUEE_LABEL_SKIN] = new MarqueeLabelSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_TEXT_INPUT_SKIN] = new InputSkinCreator();
         skinClassnameToInstanceMap[CLASSNAME_PROGRESS_BAR_SKIN] = new ProgressBarSkinCreator();
      }
      
      public function create(param1:XML) : void
      {
         var _loc2_:String = param1.@classname;
         var _loc3_:AbstractSkinCreator = skinClassnameToInstanceMap[_loc2_] as AbstractSkinCreator;
         if(_loc3_ != null)
         {
            _loc3_.create(param1);
         }
         else
         {
            UISystem.log("A SkinClass with the name= {" + _loc2_ + "} doesn´t exist.",UISystem.LOG_LEVEL_WARN);
         }
      }
   }
}

