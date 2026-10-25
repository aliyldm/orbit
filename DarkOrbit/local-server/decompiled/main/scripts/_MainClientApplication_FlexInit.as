package
{
   import com.bealearts.collection.VectorCollection;
   import com.bealearts.collection.VectorList;
   import flash.net.getClassByAlias;
   import flash.net.registerClassAlias;
   import flash.system.*;
   import flash.utils.*;
   import mx.accessibility.ButtonAccImpl;
   import mx.accessibility.DateChooserAccImpl;
   import mx.accessibility.LabelAccImpl;
   import mx.accessibility.SliderAccImpl;
   import mx.accessibility.UIComponentAccProps;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.managers.systemClasses.ChildManager;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManagerImpl;
   import mx.utils.ObjectProxy;
   import spark.accessibility.ButtonBarBaseAccImpl;
   import spark.accessibility.ButtonBaseAccImpl;
   import spark.accessibility.CheckBoxAccImpl;
   import spark.accessibility.DataGridAccImpl;
   import spark.accessibility.DropDownListBaseAccImpl;
   import spark.accessibility.ListAccImpl;
   import spark.accessibility.ListBaseAccImpl;
   import spark.accessibility.PanelAccImpl;
   import spark.accessibility.RichEditableTextAccImpl;
   import spark.accessibility.SliderBaseAccImpl;
   import spark.accessibility.TabBarAccImpl;
   import spark.accessibility.TextBaseAccImpl;
   import spark.accessibility.TitleWindowAccImpl;
   import spark.accessibility.ToggleButtonAccImpl;
   import spark.accessibility.VideoPlayerAccImpl;
   
   public class _MainClientApplication_FlexInit
   {
      
      public function _MainClientApplication_FlexInit()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var styleNames:Array;
         var i:int;
         var styleManager:IStyleManager2 = null;
         var fbs:IFlexModuleFactory = param1;
         new ChildManager(fbs);
         styleManager = new StyleManagerImpl(fbs);
         EffectManager.mx_internal::registerEffectTrigger("addedEffect","added");
         EffectManager.mx_internal::registerEffectTrigger("completeEffect","complete");
         EffectManager.mx_internal::registerEffectTrigger("creationCompleteEffect","creationComplete");
         EffectManager.mx_internal::registerEffectTrigger("focusInEffect","focusIn");
         EffectManager.mx_internal::registerEffectTrigger("focusOutEffect","focusOut");
         EffectManager.mx_internal::registerEffectTrigger("hideEffect","hide");
         EffectManager.mx_internal::registerEffectTrigger("mouseDownEffect","mouseDown");
         EffectManager.mx_internal::registerEffectTrigger("mouseUpEffect","mouseUp");
         EffectManager.mx_internal::registerEffectTrigger("moveEffect","move");
         EffectManager.mx_internal::registerEffectTrigger("removedEffect","removed");
         EffectManager.mx_internal::registerEffectTrigger("resizeEffect","resize");
         EffectManager.mx_internal::registerEffectTrigger("rollOutEffect","rollOut");
         EffectManager.mx_internal::registerEffectTrigger("rollOverEffect","rollOver");
         EffectManager.mx_internal::registerEffectTrigger("showEffect","show");
         if(Capabilities.hasAccessibility)
         {
            ListBaseAccImpl.enableAccessibility();
            ButtonBarBaseAccImpl.enableAccessibility();
            UIComponentAccProps.enableAccessibility();
            ListAccImpl.enableAccessibility();
            VideoPlayerAccImpl.enableAccessibility();
            TitleWindowAccImpl.enableAccessibility();
            ButtonAccImpl.enableAccessibility();
            TextBaseAccImpl.enableAccessibility();
            DropDownListBaseAccImpl.enableAccessibility();
            ButtonBaseAccImpl.enableAccessibility();
            LabelAccImpl.enableAccessibility();
            SliderAccImpl.enableAccessibility();
            ToggleButtonAccImpl.enableAccessibility();
            PanelAccImpl.enableAccessibility();
            SliderBaseAccImpl.enableAccessibility();
            DataGridAccImpl.enableAccessibility();
            TabBarAccImpl.enableAccessibility();
            RichEditableTextAccImpl.enableAccessibility();
            CheckBoxAccImpl.enableAccessibility();
            DateChooserAccImpl.enableAccessibility();
         }
         try
         {
            if(getClassByAlias(">com.bealearts.collection.VectorCollection") != VectorCollection)
            {
               registerClassAlias(">com.bealearts.collection.VectorCollection",VectorCollection);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.bealearts.collection.VectorCollection",VectorCollection);
         }
         try
         {
            if(getClassByAlias(">com.bealearts.collection.VectorList") != VectorList)
            {
               registerClassAlias(">com.bealearts.collection.VectorList",VectorList);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.bealearts.collection.VectorList",VectorList);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayCollection") != ArrayCollection)
            {
               registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayList") != ArrayList)
            {
               registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ObjectProxy") != ObjectProxy)
            {
               registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
         }
         styleNames = ["paragraphStartIndent","breakOpportunity","kerning","alternatingItemColors","wordSpacing","leading","fontAntiAliasType","selectionColor","labelWidth","cffHinting","contentBackgroundAlpha","fontFamily","digitCase","textSelectedColor","clearFloats","paragraphEndIndent","layoutDirection","ligatureLevel","disabledIconColor","downColor","dropShadowColor","fontWeight","interactionMode","dominantBaseline","textAlign","accentColor","justificationStyle","fontSharpness","todayColor","whiteSpaceCollapse","headerColors","contentBackgroundColor","textDecoration","fontLookup","fontStyle","chromeColor","digitWidth","focusColor","themeColor","listAutoPadding","blockProgression","showPromptWhenFocused","listStyleType","fontSize","textRollOverColor","textAlignLast","trackingRight","fontGridFitType","paragraphSpaceAfter","showErrorSkin","errorColor","justificationRule","color","backgroundDisabledColor","textShadowColor","unfocusedTextSelectionColor","paragraphSpaceBefore","textIndent","textAlpha"
         ,"locale","baselineShift","barColor","fontThickness","touchDelay","textShadowAlpha","renderingMode","textJustify","textRotation","tabStops","direction","firstBaselineOffset","lineThrough","caretColor","symbolColor","focusedTextSelectionColor","letterSpacing","disabledColor","alignmentBaseline","trackingLeft","rollOverColor","listStylePosition","iconColor","inactiveTextSelectionColor","lineHeight","leadingModel","showErrorTip","typographicCase"];
         i = 0;
         while(i < styleNames.length)
         {
            styleManager.registerInheritingStyle(styleNames[i]);
            i++;
         }
      }
   }
}

TextFieldFactory;

