package
{
   import mx.core.IFlexModuleFactory;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.skins.halo.BusyCursor;
   import mx.skins.halo.DefaultDragImage;
   import mx.skins.halo.HaloFocusRect;
   import mx.skins.halo.ToolTipBorder;
   import mx.skins.spark.BorderSkin;
   import mx.skins.spark.ButtonSkin;
   import mx.skins.spark.DateChooserNextMonthSkin;
   import mx.skins.spark.DateChooserNextYearSkin;
   import mx.skins.spark.DateChooserPrevMonthSkin;
   import mx.skins.spark.DateChooserPrevYearSkin;
   import mx.skins.spark.DateChooserRollOverIndicatorSkin;
   import mx.skins.spark.DateChooserSelectionIndicatorSkin;
   import mx.skins.spark.DateChooserTodayIndicatorSkin;
   import mx.skins.spark.DefaultButtonSkin;
   import mx.skins.spark.ProgressBarSkin;
   import mx.skins.spark.ProgressBarTrackSkin;
   import mx.skins.spark.ProgressIndeterminateSkin;
   import mx.skins.spark.ProgressMaskSkin;
   import mx.skins.spark.SliderThumbSkin;
   import mx.skins.spark.SliderTrackHighlightSkin;
   import mx.skins.spark.SliderTrackSkin;
   import mx.styles.CSSCondition;
   import mx.styles.CSSSelector;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.utils.ObjectUtil;
   import spark.components.supportClasses.ListItemDragProxy;
   import spark.skins.spark.ApplicationSkin;
   import spark.skins.spark.BorderContainerSkin;
   import spark.skins.spark.ButtonSkin;
   import spark.skins.spark.CheckBoxSkin;
   import spark.skins.spark.DataGridSkin;
   import spark.skins.spark.DefaultButtonSkin;
   import spark.skins.spark.DropDownListSkin;
   import spark.skins.spark.ErrorSkin;
   import spark.skins.spark.FocusSkin;
   import spark.skins.spark.HScrollBarSkin;
   import spark.skins.spark.HSliderSkin;
   import spark.skins.spark.ImageSkin;
   import spark.skins.spark.ListDropIndicator;
   import spark.skins.spark.ListSkin;
   import spark.skins.spark.PanelSkin;
   import spark.skins.spark.ScrollerSkin;
   import spark.skins.spark.SkinnableContainerSkin;
   import spark.skins.spark.SkinnableDataContainerSkin;
   import spark.skins.spark.TabBarSkin;
   import spark.skins.spark.TextAreaSkin;
   import spark.skins.spark.TextInputSkin;
   import spark.skins.spark.TitleWindowSkin;
   import spark.skins.spark.ToggleButtonSkin;
   import spark.skins.spark.VScrollBarSkin;
   import spark.skins.spark.VSliderSkin;
   import spark.skins.spark.VideoPlayerSkin;
   import spark.skins.spark.mediaClasses.normal.MuteButtonSkin;
   import spark.skins.spark.mediaClasses.normal.ScrubBarSkin;
   import spark.skins.spark.mediaClasses.normal.VolumeBarSkin;
   
   public class _MainClientApplication_Styles
   {
      
      private static var _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragReject_352339649:Class = _class_embed_css_Assets_swf__1877260513_mx_skins_cursor_DragReject_352339649;
      
      private static var _embed_css_Assets_swf__1877260513_cursorStretch_1144688114:Class = _class_embed_css_Assets_swf__1877260513_cursorStretch_1144688114;
      
      private static var _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragLink_1135174890:Class = _class_embed_css_Assets_swf__1877260513_mx_skins_cursor_DragLink_1135174890;
      
      private static var _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragCopy_1134912885:Class = _class_embed_css_Assets_swf__1877260513_mx_skins_cursor_DragCopy_1134912885;
      
      private static var _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragMove_1135200465:Class = _class_embed_css_Assets_swf__1877260513_mx_skins_cursor_DragMove_1135200465;
      
      private static var _embed_css_Assets_swf__1877260513_mx_skins_cursor_BusyCursor_816733451:Class = _class_embed_css_Assets_swf__1877260513_mx_skins_cursor_BusyCursor_816733451;
      
      public function _MainClientApplication_Styles()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var mergedStyle:CSSStyleDeclaration = null;
         var fbs:IFlexModuleFactory = param1;
         var styleManager:IStyleManager2 = fbs.getImplementation("mx.styles::IStyleManager2") as IStyleManager2;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Application",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Application");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = ApplicationSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.BorderContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.BorderContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = BorderContainerSkin;
               this.borderStyle = "solid";
               this.cornerRadius = 0;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = spark.skins.spark.ButtonSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = spark.skins.spark.DefaultButtonSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.CheckBox",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.CheckBox");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = CheckBoxSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.DataGrid",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.DataGrid");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DataGridSkin;
               this.stretchCursor = _embed_css_Assets_swf__1877260513_cursorStretch_1144688114;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.DropDownList",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.DropDownList");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.dropShadowVisible = true;
               this.skinClass = DropDownListSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.GridColumnHeaderGroup",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.GridColumnHeaderGroup");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.separatorAffordance = 5;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.HScrollBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.HScrollBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = HScrollBarSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.HSlider",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.HSlider");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = HSliderSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Image",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Image");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.showErrorSkin = false;
               this.enableLoadingState = false;
               this.smoothingQuality = "default";
               this.skinClass = ImageSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.List",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.List");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.dropIndicatorSkin = ListDropIndicator;
               this.skinClass = ListSkin;
               this.dragIndicatorClass = ListItemDragProxy;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.mediaClasses.MuteButton",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.mediaClasses.MuteButton");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = MuteButtonSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Panel",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Panel");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.borderColor = 0;
               this.dropShadowVisible = true;
               this.skinClass = PanelSkin;
               this.borderAlpha = 0.5;
               this.cornerRadius = 0;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.RichEditableText",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.RichEditableText");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.layoutDirection = "ltr";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Scroller",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Scroller");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ScrollerSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.mediaClasses.ScrubBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.mediaClasses.ScrubBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ScrubBarSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableDataContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.SkinnableDataContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = SkinnableDataContainerSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.supportClasses.SkinnableComponent",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.SkinnableComponent");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.errorSkin = ErrorSkin;
               this.focusSkin = FocusSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.SkinnableContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = SkinnableContainerSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("pseudo","normalWithPrompt");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.supportClasses.SkinnableTextBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.SkinnableTextBase:normalWithPrompt");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 12237498;
               this.fontStyle = "italic";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("pseudo","disabledWithPrompt");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.supportClasses.SkinnableTextBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.SkinnableTextBase:disabledWithPrompt");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 12237498;
               this.fontStyle = "italic";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TabBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TabBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = TabBarSkin;
               this.cornerRadius = 4;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.supportClasses.TextBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.TextBase");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.layoutDirection = "ltr";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextArea",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TextArea");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingBottom = 3;
               this.paddingRight = 3;
               this.skinClass = TextAreaSkin;
               this.paddingTop = 5;
               this.paddingLeft = 3;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextInput",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TextInput");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingBottom = 3;
               this.paddingRight = 3;
               this.skinClass = TextInputSkin;
               this.paddingTop = 5;
               this.paddingLeft = 3;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TitleWindow",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TitleWindow");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.borderColor = 0;
               this.dropShadowVisible = true;
               this.skinClass = TitleWindowSkin;
               this.borderAlpha = 0.8;
               this.cornerRadius = 0;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ToggleButton",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ToggleButton");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ToggleButtonSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.VideoDisplay",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.VideoDisplay");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.layoutDirection = "ltr";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.VideoPlayer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.VideoPlayer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.dropShadowVisible = true;
               this.skinClass = VideoPlayerSkin;
               this.layoutDirection = "ltr";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.mediaClasses.VolumeBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.mediaClasses.VolumeBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = VolumeBarSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.VScrollBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.VScrollBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = VScrollBarSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.VSlider",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.VSlider");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = VSliderSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("global",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("global");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paragraphStartIndent = 0;
               this.shadowDistance = 2;
               this.breakOpportunity = "auto";
               this.kerning = "default";
               this.selectionDuration = 250;
               this.leading = 2;
               this.paddingRight = 0;
               this.rollOverOpenDelay = 200;
               this.liveDragging = true;
               this.slideDuration = 300;
               this.iconPlacement = "left";
               this.textFieldClass = UITextField;
               this.layoutDirection = "ltr";
               this.borderStyle = "inset";
               this.ligatureLevel = "common";
               this.repeatDelay = 500;
               this.dropShadowColor = 0;
               this.shadowColor = 15658734;
               this.verticalAlign = "top";
               this.interactionMode = "mouse";
               this.dominantBaseline = "auto";
               this.focusAlpha = 0.55;
               this.fontSharpness = 0;
               this.justificationStyle = "auto";
               this.whiteSpaceCollapse = "collapse";
               this.textDecoration = "none";
               this.fontStyle = "normal";
               this.shadowDirection = "center";
               this.version = "4.0.0";
               this.horizontalScrollPolicy = "auto";
               this.digitWidth = "default";
               this.indicatorGap = 14;
               this.lineBreak = "toFit";
               this.borderCapColor = 9542041;
               this.focusColor = 7385838;
               this.themeColor = 7385838;
               this.fontSize = 12;
               this.textAlignLast = "start";
               this.paddingLeft = 0;
               this.selectionDisabledColor = 14540253;
               this.trackingRight = 0;
               this.smoothScrolling = true;
               this.showErrorSkin = true;
               this.useRollOver = true;
               this.unfocusedTextSelectionColor = 15263976;
               this.backgroundAlpha = 1;
               this.baselineShift = 0;
               this.textAlpha = 1;
               this.verticalGap = 6;
               this.closeDuration = 50;
               this.disabledAlpha = 0.5;
               this.fillColor = 16777215;
               this.roundedBottomCorners = true;
               this.highlightAlphas = [0.3,0];
               this.horizontalAlign = "left";
               this.verticalGridLines = true;
               this.textRotation = "auto";
               this.dropShadowVisible = false;
               this.backgroundSize = "auto";
               this.horizontalGridLines = false;
               this.tabStops = null;
               this.softKeyboardEffectDuration = 150;
               this.firstBaselineOffset = "auto";
               this.focusRoundedCorners = "tl tr bl br";
               this.lineThrough = false;
               this.focusSkin = HaloFocusRect;
               this.focusedTextSelectionColor = 11060974;
               this.symbolColor = 0;
               this.borderAlpha = 1;
               this.filled = true;
               this.openDuration = 1;
               this.disabledColor = 11187123;
               this.alignmentBaseline = "useDominantBaseline";
               this.modalTransparencyColor = 14540253;
               this.embedFonts = false;
               this.modalTransparencyDuration = 100;
               this.modalTransparency = 0.5;
               this.backgroundImageFillMode = "scale";
               this.lineHeight = "120%";
               this.typographicCase = "default";
               this.borderColor = 6908265;
               this.fontAntiAliasType = "advanced";
               this.selectionColor = 11060974;
               this.cffHinting = "horizontalStem";
               this.contentBackgroundAlpha = 1;
               this.cornerRadius = 2;
               this.borderThickness = 1;
               this.fontFamily = "Arial";
               this.indentation = 17;
               this.paddingBottom = 0;
               this.digitCase = "default";
               this.repeatInterval = 35;
               this.textSelectedColor = 0;
               this.paragraphEndIndent = 0;
               this.disabledIconColor = 10066329;
               this.fontWeight = "normal";
               this.borderVisible = true;
               this.focusBlendMode = "normal";
               this.textAlign = "start";
               this.accentColor = 39423;
               this.shadowCapColor = 14015965;
               this.contentBackgroundColor = 16777215;
               this.fontLookup = "embeddedCFF";
               this.chromeColor = 13421772;
               this.columnGap = 20;
               this.focusThickness = 2;
               this.verticalGridLineColor = 14015965;
               this.blockProgression = "tb";
               this.textRollOverColor = 0;
               this.fillAlphas = [0.6,0.4,0.75,0.65];
               this.horizontalGridLineColor = 16250871;
               this.strokeWidth = 1;
               this.fontGridFitType = "pixel";
               this.errorColor = 16646144;
               this.paragraphSpaceAfter = 0;
               this.justificationRule = "auto";
               this.borderSides = "left top right bottom";
               this.color = 0;
               this.buttonColor = 7305079;
               this.fillColors = [16777215,13421772,16777215,15658734];
               this.paragraphSpaceBefore = 0;
               this.locale = "en";
               this.textIndent = 0;
               this.fontThickness = 0;
               this.renderingMode = "cff";
               this.textJustify = "interWord";
               this.fullScreenHideControlsDelay = 3000;
               this.columnWidth = "auto";
               this.paddingTop = 0;
               this.direction = "ltr";
               this.fixedThumbSize = false;
               this.caretColor = 92159;
               this.letterSpacing = 0;
               this.borderWeight = 1;
               this.columnCount = "auto";
               this.bevel = true;
               this.verticalScrollPolicy = "auto";
               this.trackingLeft = 0;
               this.horizontalGap = 8;
               this.rollOverColor = 13556719;
               this.modalTransparencyBlur = 3;
               this.stroked = false;
               this.iconColor = 1118481;
               this.inactiveTextSelectionColor = 15263976;
               this.leadingModel = "auto";
               this.showErrorTip = true;
               this.autoThumbVisibility = true;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","dateFieldPopup");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".dateFieldPopup");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.borderThickness = 1;
               this.backgroundColor = 16777215;
               this.dropShadowVisible = true;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","errorTip");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".errorTip");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.borderColor = 13510953;
               this.paddingBottom = 4;
               this.color = 16777215;
               this.paddingRight = 4;
               this.fontSize = 10;
               this.paddingTop = 4;
               this.borderStyle = "errorTipRight";
               this.shadowColor = 0;
               this.paddingLeft = 4;
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","headerDragProxyStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".headerDragProxyStyle");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","swatchPanelTextField");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".swatchPanelTextField");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.highlightColor = 12897484;
               this.backgroundColor = 16777215;
               this.borderColor = 14015965;
               this.borderCapColor = 9542041;
               this.buttonColor = 7305079;
               this.shadowCapColor = 14015965;
               this.paddingRight = 5;
               this.borderStyle = "inset";
               this.paddingLeft = 5;
               this.shadowColor = 14015965;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","todayStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".todayStyle");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","weekDayStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".weekDayStyle");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.textAlign = "center";
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","windowStatus");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".windowStatus");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 6710886;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","windowStyles");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".windowStyles");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.horizontalGap = 2;
               this.textAlign = "center";
               this.paddingRight = 6;
               this.skin = mx.skins.spark.ButtonSkin;
               this.labelVerticalOffset = 1;
               this.verticalGap = 2;
               this.paddingLeft = 6;
               this.emphasizedSkin = mx.skins.spark.DefaultButtonSkin;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.CalendarLayout",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.CalendarLayout");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.horizontalGap = 7;
               this.paddingBottom = 10;
               this.textAlign = "center";
               this.todayColor = 8487297;
               this.paddingRight = 6;
               this.paddingTop = 6;
               this.verticalGap = 6;
               this.paddingLeft = 6;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.DateChooser",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.DateChooser");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.todayStyleName = "todayStyle";
               this.prevMonthSkin = DateChooserPrevMonthSkin;
               this.todayIndicatorSkin = DateChooserTodayIndicatorSkin;
               this.rollOverIndicatorSkin = DateChooserRollOverIndicatorSkin;
               this.todayColor = 13029595;
               this.prevYearSkin = DateChooserPrevYearSkin;
               this.borderSkin = BorderSkin;
               this.nextMonthSkin = DateChooserNextMonthSkin;
               this.selectionIndicatorSkin = DateChooserSelectionIndicatorSkin;
               this.nextYearSkin = DateChooserNextYearSkin;
               this.cornerRadius = 0;
               this.weekDayStyleName = "weekDayStyle";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.managers.DragManager",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.managers.DragManager");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.linkCursor = _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragLink_1135174890;
               this.rejectCursor = _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragReject_352339649;
               this.copyCursor = _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragCopy_1134912885;
               this.moveCursor = _embed_css_Assets_swf__1877260513_mx_skins_cursor_DragMove_1135200465;
               this.defaultDragImageSkin = DefaultDragImage;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.HSlider",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.HSlider");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.dataTipPlacement = "top";
               this.tickLength = 4;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.ProgressBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.ProgressBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.indeterminateSkin = ProgressIndeterminateSkin;
               this.barSkin = ProgressBarSkin;
               this.leading = 0;
               this.trackSkin = ProgressBarTrackSkin;
               this.indeterminateMoveInterval = 14;
               this.maskSkin = ProgressMaskSkin;
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.sliderClasses.Slider",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.sliderClasses.Slider");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.thumbSkin = SliderThumbSkin;
               this.labelOffset = -10;
               this.showTrackHighlight = false;
               this.tickOffset = -6;
               this.tickThickness = 1;
               this.thumbOffset = 0;
               this.trackHighlightSkin = SliderTrackHighlightSkin;
               this.tickColor = 7305079;
               this.trackSkin = SliderTrackSkin;
               this.dataTipPrecision = 2;
               this.slideDuration = 300;
               this.dataTipOffset = 16;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.managers.CursorManager",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.managers.CursorManager");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.busyCursor = BusyCursor;
               this.busyCursorBackground = _embed_css_Assets_swf__1877260513_mx_skins_cursor_BusyCursor_816733451;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.ToolTip",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.ToolTip");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777164;
               this.borderColor = 9542041;
               this.paddingBottom = 2;
               this.paddingRight = 4;
               this.backgroundAlpha = 0.95;
               this.fontSize = 10;
               this.paddingTop = 2;
               this.borderSkin = ToolTipBorder;
               this.borderStyle = "toolTip";
               this.paddingLeft = 4;
               this.cornerRadius = 2;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
      }
   }
}

