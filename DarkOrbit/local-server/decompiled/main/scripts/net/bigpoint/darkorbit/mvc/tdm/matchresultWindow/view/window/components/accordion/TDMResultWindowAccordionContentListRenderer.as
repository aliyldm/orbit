package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.accordion
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import flashx.textLayout.formats.TextAlign;
   import mx.binding.*;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.GradientEntry;
   import mx.graphics.LinearGradient;
   import mx.graphics.SolidColor;
   import mx.states.SetProperty;
   import mx.states.SetStyle;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMResultWindowTabContentVo;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.supportClasses.ItemRenderer;
   import spark.filters.GlowFilter;
   import spark.layouts.BasicLayout;
   import spark.layouts.VerticalLayout;
   import spark.primitives.Graphic;
   import spark.primitives.Path;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class TDMResultWindowAccordionContentListRenderer extends ItemRenderer implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _TDMResultWindowAccordionContentListRenderer_GlowFilter1:GlowFilter;
      
      public var _TDMResultWindowAccordionContentListRenderer_GlowFilter2:GlowFilter;
      
      public var _TDMResultWindowAccordionContentListRenderer_GlowFilter3:GlowFilter;
      
      private var _165277553_TDMResultWindowAccordionContentListRenderer_GradientEntry1:GradientEntry;
      
      private var _165277554_TDMResultWindowAccordionContentListRenderer_GradientEntry2:GradientEntry;
      
      private var _2053859861_TDMResultWindowAccordionContentListRenderer_Graphic1:Graphic;
      
      private var _1682160204_TDMResultWindowAccordionContentListRenderer_Group1:spark.components.Group;
      
      public var _TDMResultWindowAccordionContentListRenderer_Group2:spark.components.Group;
      
      private var _1154832310_TDMResultWindowAccordionContentListRenderer_Path1:Path;
      
      private var _1152882069_TDMResultWindowAccordionContentListRenderer_Rect1:Rect;
      
      private var _1488955044_TDMResultWindowAccordionContentListRenderer_SetProperty1:SetProperty;
      
      private var _1488955043_TDMResultWindowAccordionContentListRenderer_SetProperty2:SetProperty;
      
      private var _1488955042_TDMResultWindowAccordionContentListRenderer_SetProperty3:SetProperty;
      
      private var _1488955041_TDMResultWindowAccordionContentListRenderer_SetProperty4:SetProperty;
      
      private var _1488955040_TDMResultWindowAccordionContentListRenderer_SetProperty5:SetProperty;
      
      private var _1488955039_TDMResultWindowAccordionContentListRenderer_SetProperty6:SetProperty;
      
      private var _1488955038_TDMResultWindowAccordionContentListRenderer_SetProperty7:SetProperty;
      
      private var _1488955037_TDMResultWindowAccordionContentListRenderer_SetProperty8:SetProperty;
      
      private var _1777436608_TDMResultWindowAccordionContentListRenderer_SetStyle1:SetStyle;
      
      private var _1777436607_TDMResultWindowAccordionContentListRenderer_SetStyle2:SetStyle;
      
      private var _1777436606_TDMResultWindowAccordionContentListRenderer_SetStyle3:SetStyle;
      
      private var _1777436605_TDMResultWindowAccordionContentListRenderer_SetStyle4:SetStyle;
      
      private var _1777436604_TDMResultWindowAccordionContentListRenderer_SetStyle5:SetStyle;
      
      private var _1777436603_TDMResultWindowAccordionContentListRenderer_SetStyle6:SetStyle;
      
      public var _TDMResultWindowAccordionContentListRenderer_SolidColor1:SolidColor;
      
      public var _TDMResultWindowAccordionContentListRenderer_SolidColor2:SolidColor;
      
      public var _TDMResultWindowAccordionContentListRenderer_SolidColor3:SolidColor;
      
      private var _951530617content:spark.components.Group;
      
      private var _1588604490killDeath:TDMAccordionContent;
      
      private var _694421601peakDMG:TDMAccordionContent;
      
      private var _1240887304pointDelta:TDMAccordionContent;
      
      private var _984130703topLable:Label;
      
      private var _2145619868topLablePointsDelta:Label;
      
      private var _36822877totalDMGgiven:TDMAccordionContent;
      
      private var _25066003totalDMGtaken:TDMAccordionContent;
      
      private var _896599986winnigStreak:TDMAccordionContent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMResultWindowAccordionContentListRenderer()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._TDMResultWindowAccordionContentListRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_accordion_TDMResultWindowAccordionContentListRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMResultWindowAccordionContentListRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.autoDrawBackground = true;
         this.mouseEnabled = false;
         this.percentWidth = 100;
         this.mxmlContent = [this._TDMResultWindowAccordionContentListRenderer_Group1_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Path1",
               "name":"filters",
               "value":[this._TDMResultWindowAccordionContentListRenderer_GlowFilter3_i()]
            }),new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Group1",
               "name":"layout",
               "value":this._TDMResultWindowAccordionContentListRenderer_BasicLayout1_c()
            }),new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Path1",
               "name":"fill",
               "value":this._TDMResultWindowAccordionContentListRenderer_SolidColor2_i()
            }),this._TDMResultWindowAccordionContentListRenderer_SetStyle1 = SetStyle(new SetStyle().initializeFromObject({
               "target":"topLable",
               "name":"color",
               "value":undefined
            })),this._TDMResultWindowAccordionContentListRenderer_SetStyle4 = SetStyle(new SetStyle().initializeFromObject({
               "target":"topLablePointsDelta",
               "name":"color",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"content",
               "name":"y",
               "value":0
            }),this._TDMResultWindowAccordionContentListRenderer_SetProperty6 = SetProperty(new SetProperty().initializeFromObject({
               "target":"content",
               "name":"visible",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"content",
               "name":"height",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"content",
               "name":"layout",
               "value":this._TDMResultWindowAccordionContentListRenderer_BasicLayout3_c()
            })]
         }),new State({
            "name":"hovered",
            "basedOn":"normal",
            "overrides":[this._TDMResultWindowAccordionContentListRenderer_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "isBaseValueDataBound":true,
               "target":"_TDMResultWindowAccordionContentListRenderer_GradientEntry1",
               "name":"color",
               "value":undefined
            })),this._TDMResultWindowAccordionContentListRenderer_SetProperty3 = SetProperty(new SetProperty().initializeFromObject({
               "isBaseValueDataBound":true,
               "target":"_TDMResultWindowAccordionContentListRenderer_GradientEntry2",
               "name":"color",
               "value":undefined
            }))]
         }),new State({
            "name":"isHero",
            "basedOn":"normal",
            "overrides":[this._TDMResultWindowAccordionContentListRenderer_SetStyle2 = SetStyle(new SetStyle().initializeFromObject({
               "target":"topLable",
               "name":"color",
               "value":undefined
            })),this._TDMResultWindowAccordionContentListRenderer_SetStyle5 = SetStyle(new SetStyle().initializeFromObject({
               "target":"topLablePointsDelta",
               "name":"color",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"content",
               "name":"y",
               "value":0
            }),this._TDMResultWindowAccordionContentListRenderer_SetProperty7 = SetProperty(new SetProperty().initializeFromObject({
               "target":"content",
               "name":"visible",
               "value":undefined
            }))]
         }),new State({
            "name":"selected",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Path1",
               "name":"filters",
               "value":[this._TDMResultWindowAccordionContentListRenderer_GlowFilter2_i()]
            }),new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Group1",
               "name":"layout",
               "value":this._TDMResultWindowAccordionContentListRenderer_VerticalLayout1_c()
            }),this._TDMResultWindowAccordionContentListRenderer_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "isBaseValueDataBound":true,
               "target":"_TDMResultWindowAccordionContentListRenderer_GradientEntry1",
               "name":"color",
               "value":undefined
            })),this._TDMResultWindowAccordionContentListRenderer_SetProperty4 = SetProperty(new SetProperty().initializeFromObject({
               "isBaseValueDataBound":true,
               "target":"_TDMResultWindowAccordionContentListRenderer_GradientEntry2",
               "name":"color",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Graphic1",
               "name":"left",
               "value":8
            }),new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Graphic1",
               "name":"top",
               "value":5
            }),this._TDMResultWindowAccordionContentListRenderer_SetProperty5 = SetProperty(new SetProperty().initializeFromObject({
               "isBaseValueDataBound":true,
               "target":"_TDMResultWindowAccordionContentListRenderer_Path1",
               "name":"data",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Path1",
               "name":"fill",
               "value":this._TDMResultWindowAccordionContentListRenderer_SolidColor3_i()
            }),this._TDMResultWindowAccordionContentListRenderer_SetStyle3 = SetStyle(new SetStyle().initializeFromObject({
               "target":"topLable",
               "name":"color",
               "value":undefined
            })),this._TDMResultWindowAccordionContentListRenderer_SetStyle6 = SetStyle(new SetStyle().initializeFromObject({
               "target":"topLablePointsDelta",
               "name":"color",
               "value":undefined
            })),this._TDMResultWindowAccordionContentListRenderer_SetProperty8 = SetProperty(new SetProperty().initializeFromObject({
               "target":"content",
               "name":"visible",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"content",
               "name":"layout",
               "value":this._TDMResultWindowAccordionContentListRenderer_VerticalLayout2_c()
            })]
         }),new State({
            "name":"hoveredAndSelected",
            "basedOn":"selected",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_TDMResultWindowAccordionContentListRenderer_Rect1",
               "name":"filters",
               "value":[this._TDMResultWindowAccordionContentListRenderer_GlowFilter1_i()]
            })]
         })];
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle1",this._TDMResultWindowAccordionContentListRenderer_SetStyle1);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle4",this._TDMResultWindowAccordionContentListRenderer_SetStyle4);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty6",this._TDMResultWindowAccordionContentListRenderer_SetProperty6);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty1",this._TDMResultWindowAccordionContentListRenderer_SetProperty1);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty3",this._TDMResultWindowAccordionContentListRenderer_SetProperty3);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle2",this._TDMResultWindowAccordionContentListRenderer_SetStyle2);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle5",this._TDMResultWindowAccordionContentListRenderer_SetStyle5);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty7",this._TDMResultWindowAccordionContentListRenderer_SetProperty7);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty2",this._TDMResultWindowAccordionContentListRenderer_SetProperty2);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty4",this._TDMResultWindowAccordionContentListRenderer_SetProperty4);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty5",this._TDMResultWindowAccordionContentListRenderer_SetProperty5);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle3",this._TDMResultWindowAccordionContentListRenderer_SetStyle3);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle6",this._TDMResultWindowAccordionContentListRenderer_SetStyle6);
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty8",this._TDMResultWindowAccordionContentListRenderer_SetProperty8);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMResultWindowAccordionContentListRenderer._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function set _3076010data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:TDMResultWindowTabContentVo = data as TDMResultWindowTabContentVo;
         if(_loc2_)
         {
            this.topLable.text = _loc2_.palyerNameLable.left;
            this.topLablePointsDelta.text = _loc2_.palyerNameLable.right;
            this.pointDelta.leftText = _loc2_.pointsDeltaLable.left;
            this.winnigStreak.leftText = _loc2_.winnigStreakLable.left;
            this.peakDMG.leftText = _loc2_.peakDamageLable.left;
            this.totalDMGtaken.leftText = _loc2_.damageTakenLable.left;
            this.totalDMGgiven.leftText = _loc2_.damageGivenLable.left;
            this.killDeath.leftText = _loc2_.killLDeathable.left;
            this.pointDelta.rightText = _loc2_.pointsDeltaLable.right;
            this.winnigStreak.rightText = _loc2_.winnigStreakLable.right;
            this.peakDMG.rightText = _loc2_.peakDamageLable.right;
            this.totalDMGtaken.rightText = _loc2_.damageTakenLable.right;
            this.totalDMGgiven.rightText = _loc2_.damageGivenLable.right;
            this.killDeath.rightText = _loc2_.killLDeathable.right;
         }
      }
      
      override protected function getCurrentRendererState() : String
      {
         var _loc1_:TDMResultWindowTabContentVo = data as TDMResultWindowTabContentVo;
         var _loc2_:String = super.getCurrentRendererState();
         if(_loc1_)
         {
            if(_loc1_.isHero && currentState == "normal")
            {
               return "isHero";
            }
         }
         if(hovered && selected)
         {
            return "hoveredAndSelected";
         }
         return _loc2_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._TDMResultWindowAccordionContentListRenderer_BasicLayout2_c();
         _loc1_.mxmlContent = [this._TDMResultWindowAccordionContentListRenderer_Group2_i(),this._TDMResultWindowAccordionContentListRenderer_Group4_i()];
         _loc1_.id = "_TDMResultWindowAccordionContentListRenderer_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMResultWindowAccordionContentListRenderer_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_Group1",this._TDMResultWindowAccordionContentListRenderer_Group1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_BasicLayout2_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._TDMResultWindowAccordionContentListRenderer_Rect1_i(),this._TDMResultWindowAccordionContentListRenderer_Rect2_c(),this._TDMResultWindowAccordionContentListRenderer_Group3_c()];
         _loc1_.id = "_TDMResultWindowAccordionContentListRenderer_Group2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMResultWindowAccordionContentListRenderer_Group2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_Group2",this._TDMResultWindowAccordionContentListRenderer_Group2);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.fill = this._TDMResultWindowAccordionContentListRenderer_LinearGradient1_c();
         _loc1_.initialized(this,"_TDMResultWindowAccordionContentListRenderer_Rect1");
         this._TDMResultWindowAccordionContentListRenderer_Rect1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_Rect1",this._TDMResultWindowAccordionContentListRenderer_Rect1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_LinearGradient1_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._TDMResultWindowAccordionContentListRenderer_GradientEntry1_i(),this._TDMResultWindowAccordionContentListRenderer_GradientEntry2_i()];
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_GradientEntry1_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         this._TDMResultWindowAccordionContentListRenderer_GradientEntry1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_GradientEntry1",this._TDMResultWindowAccordionContentListRenderer_GradientEntry1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_GradientEntry2_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         this._TDMResultWindowAccordionContentListRenderer_GradientEntry2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_GradientEntry2",this._TDMResultWindowAccordionContentListRenderer_GradientEntry2);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Rect2_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.height = 1;
         _loc1_.percentWidth = 100;
         _loc1_.fill = this._TDMResultWindowAccordionContentListRenderer_SolidColor1_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._TDMResultWindowAccordionContentListRenderer_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SolidColor1",this._TDMResultWindowAccordionContentListRenderer_SolidColor1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._TDMResultWindowAccordionContentListRenderer_Graphic1_i(),this._TDMResultWindowAccordionContentListRenderer_Label1_i(),this._TDMResultWindowAccordionContentListRenderer_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Graphic1_i() : Graphic
      {
         var _loc1_:Graphic = new Graphic();
         _loc1_.left = 10;
         _loc1_.top = 3;
         _loc1_.mxmlContent = [this._TDMResultWindowAccordionContentListRenderer_Path1_i()];
         _loc1_.id = "_TDMResultWindowAccordionContentListRenderer_Graphic1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMResultWindowAccordionContentListRenderer_Graphic1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_Graphic1",this._TDMResultWindowAccordionContentListRenderer_Graphic1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Path1_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.initialized(this,"_TDMResultWindowAccordionContentListRenderer_Path1");
         this._TDMResultWindowAccordionContentListRenderer_Path1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_Path1",this._TDMResultWindowAccordionContentListRenderer_Path1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.left = 25;
         _loc1_.setStyle("paddingBottom",3);
         _loc1_.setStyle("paddingTop",3);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.id = "topLable";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topLable = _loc1_;
         BindingManager.executeBindings(this,"topLable",this.topLable);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.right = 25;
         _loc1_.setStyle("paddingBottom",3);
         _loc1_.setStyle("paddingTop",3);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.id = "topLablePointsDelta";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topLablePointsDelta = _loc1_;
         BindingManager.executeBindings(this,"topLablePointsDelta",this.topLablePointsDelta);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_Group4_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.top = 0;
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._TDMResultWindowAccordionContentListRenderer_BasicLayout4_c();
         _loc1_.mxmlContent = [this._TDMResultWindowAccordionContentListRenderer_TDMAccordionContent1_i(),this._TDMResultWindowAccordionContentListRenderer_TDMAccordionContent2_i(),this._TDMResultWindowAccordionContentListRenderer_TDMAccordionContent3_i(),this._TDMResultWindowAccordionContentListRenderer_TDMAccordionContent4_i(),this._TDMResultWindowAccordionContentListRenderer_TDMAccordionContent5_i(),this._TDMResultWindowAccordionContentListRenderer_TDMAccordionContent6_i()];
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_BasicLayout4_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_TDMAccordionContent1_i() : TDMAccordionContent
      {
         var _loc1_:TDMAccordionContent = new TDMAccordionContent();
         _loc1_.id = "killDeath";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.killDeath = _loc1_;
         BindingManager.executeBindings(this,"killDeath",this.killDeath);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_TDMAccordionContent2_i() : TDMAccordionContent
      {
         var _loc1_:TDMAccordionContent = new TDMAccordionContent();
         _loc1_.id = "pointDelta";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.pointDelta = _loc1_;
         BindingManager.executeBindings(this,"pointDelta",this.pointDelta);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_TDMAccordionContent3_i() : TDMAccordionContent
      {
         var _loc1_:TDMAccordionContent = new TDMAccordionContent();
         _loc1_.id = "winnigStreak";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.winnigStreak = _loc1_;
         BindingManager.executeBindings(this,"winnigStreak",this.winnigStreak);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_TDMAccordionContent4_i() : TDMAccordionContent
      {
         var _loc1_:TDMAccordionContent = new TDMAccordionContent();
         _loc1_.id = "peakDMG";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.peakDMG = _loc1_;
         BindingManager.executeBindings(this,"peakDMG",this.peakDMG);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_TDMAccordionContent5_i() : TDMAccordionContent
      {
         var _loc1_:TDMAccordionContent = new TDMAccordionContent();
         _loc1_.id = "totalDMGtaken";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.totalDMGtaken = _loc1_;
         BindingManager.executeBindings(this,"totalDMGtaken",this.totalDMGtaken);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_TDMAccordionContent6_i() : TDMAccordionContent
      {
         var _loc1_:TDMAccordionContent = new TDMAccordionContent();
         _loc1_.id = "totalDMGgiven";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.totalDMGgiven = _loc1_;
         BindingManager.executeBindings(this,"totalDMGgiven",this.totalDMGgiven);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_GlowFilter3_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         _loc1_.strength = 1;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         this._TDMResultWindowAccordionContentListRenderer_GlowFilter3 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_GlowFilter3",this._TDMResultWindowAccordionContentListRenderer_GlowFilter3);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_BasicLayout1_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_SolidColor2_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._TDMResultWindowAccordionContentListRenderer_SolidColor2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SolidColor2",this._TDMResultWindowAccordionContentListRenderer_SolidColor2);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_BasicLayout3_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_GlowFilter2_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         _loc1_.strength = 1;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         this._TDMResultWindowAccordionContentListRenderer_GlowFilter2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_GlowFilter2",this._TDMResultWindowAccordionContentListRenderer_GlowFilter2);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_SolidColor3_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._TDMResultWindowAccordionContentListRenderer_SolidColor3 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_SolidColor3",this._TDMResultWindowAccordionContentListRenderer_SolidColor3);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_VerticalLayout2_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_GlowFilter1_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         _loc1_.inner = true;
         _loc1_.blurX = 7;
         _loc1_.blurY = 7;
         _loc1_.alpha = 0.5;
         this._TDMResultWindowAccordionContentListRenderer_GlowFilter1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowAccordionContentListRenderer_GlowFilter1",this._TDMResultWindowAccordionContentListRenderer_GlowFilter1);
         return _loc1_;
      }
      
      private function _TDMResultWindowAccordionContentListRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Boolean
         {
            return false;
         },null,"_TDMResultWindowAccordionContentListRenderer_Group1.mouseEnabled");
         result[1] = new Binding(this,function():Boolean
         {
            return true;
         },null,"_TDMResultWindowAccordionContentListRenderer_Group2.buttonMode");
         result[2] = new Binding(this,function():Boolean
         {
            return true;
         },null,"_TDMResultWindowAccordionContentListRenderer_Group2.mouseChildren");
         result[3] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.GRADIENT_SELECTED_COLOR_0;
         },null,"_TDMResultWindowAccordionContentListRenderer_GradientEntry1.color");
         result[4] = new Binding(this,function():*
         {
            return TDMResultWindowConstants.GRADIENT_COLOR_0;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty1.value");
         result[5] = new Binding(this,function():*
         {
            return TDMResultWindowConstants.GRADIENT_SELECTED_COLOR_0;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty2.value");
         result[6] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.GRADIENT_SELECTED_COLOR_1;
         },null,"_TDMResultWindowAccordionContentListRenderer_GradientEntry2.color");
         result[7] = new Binding(this,function():*
         {
            return TDMResultWindowConstants.GRADIENT_COLOR_1;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty3.value");
         result[8] = new Binding(this,function():*
         {
            return TDMResultWindowConstants.GRADIENT_SELECTED_COLOR_1;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty4.value");
         result[9] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.HOVERED_FILTER_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_GlowFilter1.color");
         result[10] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.GRADIENT_TOP_LINE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SolidColor1.color");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = TDMResultWindowConstants.TRIANGLE_PATH;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMResultWindowAccordionContentListRenderer_Path1.data");
         result[12] = new Binding(this,function():*
         {
            return TDMResultWindowConstants.TRIANGLE_SELECTED_PATH;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty5.value");
         result[13] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ACCORDION_TRIANGLE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SolidColor2.color");
         result[14] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ACCORDION_SELECTDE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SolidColor3.color");
         result[15] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ACCORDION_SELECTDE_COLOR_GLOW;
         },null,"_TDMResultWindowAccordionContentListRenderer_GlowFilter2.color");
         result[16] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ACCORDION_COLOR_GLOW;
         },null,"_TDMResultWindowAccordionContentListRenderer_GlowFilter3.color");
         result[17] = new Binding(this,function():Object
         {
            return TDMResultWindowConstants.ACCORDION_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetStyle1.value");
         result[18] = new Binding(this,function():Object
         {
            return TDMResultWindowConstants.ACCORDION_SELECTDE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetStyle2.value");
         result[19] = new Binding(this,function():Object
         {
            return TDMResultWindowConstants.ACCORDION_SELECTDE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetStyle3.value");
         result[20] = new Binding(this,function():Boolean
         {
            return false;
         },null,"topLable.mouseEnabled");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topLable.setStyle("fontFamily",param1);
         },"topLable.fontFamily");
         result[22] = new Binding(this,function():Object
         {
            return TDMResultWindowConstants.ACCORDION_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetStyle4.value");
         result[23] = new Binding(this,function():Object
         {
            return TDMResultWindowConstants.ACCORDION_SELECTDE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetStyle5.value");
         result[24] = new Binding(this,function():Object
         {
            return TDMResultWindowConstants.ACCORDION_SELECTDE_COLOR;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetStyle6.value");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("result_window_points_delta");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"topLablePointsDelta.toolTip");
         result[26] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.RIGHT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topLablePointsDelta.setStyle("textAlign",param1);
         },"topLablePointsDelta.textAlign");
         result[27] = new Binding(this,function():Boolean
         {
            return true;
         },null,"topLablePointsDelta.mouseEnabled");
         result[28] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topLablePointsDelta.setStyle("fontFamily",param1);
         },"topLablePointsDelta.fontFamily");
         result[29] = new Binding(this,function():*
         {
            return false;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty6.value");
         result[30] = new Binding(this,function():*
         {
            return false;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty7.value");
         result[31] = new Binding(this,function():*
         {
            return true;
         },null,"_TDMResultWindowAccordionContentListRenderer_SetProperty8.value");
         result[32] = new Binding(this,function():Boolean
         {
            return false;
         },null,"content.mouseEnabled");
         result[33] = new Binding(this,function():Boolean
         {
            return false;
         },null,"content.mouseChildren");
         result[34] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.ACCORDION_PADDING_LEFT_AND_RIGHT;
         },null,"killDeath.padding");
         result[35] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ROW_COLOR_1;
         },null,"killDeath.bgcolor");
         result[36] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.ACCORDION_PADDING_LEFT_AND_RIGHT;
         },null,"pointDelta.padding");
         result[37] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ROW_COLOR_0;
         },null,"pointDelta.bgcolor");
         result[38] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.ACCORDION_PADDING_LEFT_AND_RIGHT;
         },null,"winnigStreak.padding");
         result[39] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ROW_COLOR_1;
         },null,"winnigStreak.bgcolor");
         result[40] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.ACCORDION_PADDING_LEFT_AND_RIGHT;
         },null,"peakDMG.padding");
         result[41] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ROW_COLOR_0;
         },null,"peakDMG.bgcolor");
         result[42] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.ACCORDION_PADDING_LEFT_AND_RIGHT;
         },null,"totalDMGtaken.padding");
         result[43] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ROW_COLOR_1;
         },null,"totalDMGtaken.bgcolor");
         result[44] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.ACCORDION_PADDING_LEFT_AND_RIGHT;
         },null,"totalDMGgiven.padding");
         result[45] = new Binding(this,function():uint
         {
            return TDMResultWindowConstants.ROW_COLOR_0;
         },null,"totalDMGgiven.bgcolor");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_GradientEntry1() : GradientEntry
      {
         return this._165277553_TDMResultWindowAccordionContentListRenderer_GradientEntry1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_GradientEntry1(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._165277553_TDMResultWindowAccordionContentListRenderer_GradientEntry1;
         if(_loc2_ !== param1)
         {
            this._165277553_TDMResultWindowAccordionContentListRenderer_GradientEntry1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_GradientEntry1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_GradientEntry2() : GradientEntry
      {
         return this._165277554_TDMResultWindowAccordionContentListRenderer_GradientEntry2;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_GradientEntry2(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._165277554_TDMResultWindowAccordionContentListRenderer_GradientEntry2;
         if(_loc2_ !== param1)
         {
            this._165277554_TDMResultWindowAccordionContentListRenderer_GradientEntry2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_GradientEntry2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_Graphic1() : Graphic
      {
         return this._2053859861_TDMResultWindowAccordionContentListRenderer_Graphic1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_Graphic1(param1:Graphic) : void
      {
         var _loc2_:Object = this._2053859861_TDMResultWindowAccordionContentListRenderer_Graphic1;
         if(_loc2_ !== param1)
         {
            this._2053859861_TDMResultWindowAccordionContentListRenderer_Graphic1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_Graphic1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_Group1() : spark.components.Group
      {
         return this._1682160204_TDMResultWindowAccordionContentListRenderer_Group1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_Group1(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1682160204_TDMResultWindowAccordionContentListRenderer_Group1;
         if(_loc2_ !== param1)
         {
            this._1682160204_TDMResultWindowAccordionContentListRenderer_Group1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_Group1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_Path1() : Path
      {
         return this._1154832310_TDMResultWindowAccordionContentListRenderer_Path1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_Path1(param1:Path) : void
      {
         var _loc2_:Object = this._1154832310_TDMResultWindowAccordionContentListRenderer_Path1;
         if(_loc2_ !== param1)
         {
            this._1154832310_TDMResultWindowAccordionContentListRenderer_Path1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_Path1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_Rect1() : Rect
      {
         return this._1152882069_TDMResultWindowAccordionContentListRenderer_Rect1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_Rect1(param1:Rect) : void
      {
         var _loc2_:Object = this._1152882069_TDMResultWindowAccordionContentListRenderer_Rect1;
         if(_loc2_ !== param1)
         {
            this._1152882069_TDMResultWindowAccordionContentListRenderer_Rect1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_Rect1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty1() : SetProperty
      {
         return this._1488955044_TDMResultWindowAccordionContentListRenderer_SetProperty1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955044_TDMResultWindowAccordionContentListRenderer_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._1488955044_TDMResultWindowAccordionContentListRenderer_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty2() : SetProperty
      {
         return this._1488955043_TDMResultWindowAccordionContentListRenderer_SetProperty2;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955043_TDMResultWindowAccordionContentListRenderer_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._1488955043_TDMResultWindowAccordionContentListRenderer_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty3() : SetProperty
      {
         return this._1488955042_TDMResultWindowAccordionContentListRenderer_SetProperty3;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty3(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955042_TDMResultWindowAccordionContentListRenderer_SetProperty3;
         if(_loc2_ !== param1)
         {
            this._1488955042_TDMResultWindowAccordionContentListRenderer_SetProperty3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty4() : SetProperty
      {
         return this._1488955041_TDMResultWindowAccordionContentListRenderer_SetProperty4;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty4(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955041_TDMResultWindowAccordionContentListRenderer_SetProperty4;
         if(_loc2_ !== param1)
         {
            this._1488955041_TDMResultWindowAccordionContentListRenderer_SetProperty4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty5() : SetProperty
      {
         return this._1488955040_TDMResultWindowAccordionContentListRenderer_SetProperty5;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty5(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955040_TDMResultWindowAccordionContentListRenderer_SetProperty5;
         if(_loc2_ !== param1)
         {
            this._1488955040_TDMResultWindowAccordionContentListRenderer_SetProperty5 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty5",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty6() : SetProperty
      {
         return this._1488955039_TDMResultWindowAccordionContentListRenderer_SetProperty6;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty6(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955039_TDMResultWindowAccordionContentListRenderer_SetProperty6;
         if(_loc2_ !== param1)
         {
            this._1488955039_TDMResultWindowAccordionContentListRenderer_SetProperty6 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty6",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty7() : SetProperty
      {
         return this._1488955038_TDMResultWindowAccordionContentListRenderer_SetProperty7;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty7(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955038_TDMResultWindowAccordionContentListRenderer_SetProperty7;
         if(_loc2_ !== param1)
         {
            this._1488955038_TDMResultWindowAccordionContentListRenderer_SetProperty7 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty7",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetProperty8() : SetProperty
      {
         return this._1488955037_TDMResultWindowAccordionContentListRenderer_SetProperty8;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetProperty8(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1488955037_TDMResultWindowAccordionContentListRenderer_SetProperty8;
         if(_loc2_ !== param1)
         {
            this._1488955037_TDMResultWindowAccordionContentListRenderer_SetProperty8 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetProperty8",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetStyle1() : SetStyle
      {
         return this._1777436608_TDMResultWindowAccordionContentListRenderer_SetStyle1;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetStyle1(param1:SetStyle) : void
      {
         var _loc2_:Object = this._1777436608_TDMResultWindowAccordionContentListRenderer_SetStyle1;
         if(_loc2_ !== param1)
         {
            this._1777436608_TDMResultWindowAccordionContentListRenderer_SetStyle1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetStyle2() : SetStyle
      {
         return this._1777436607_TDMResultWindowAccordionContentListRenderer_SetStyle2;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetStyle2(param1:SetStyle) : void
      {
         var _loc2_:Object = this._1777436607_TDMResultWindowAccordionContentListRenderer_SetStyle2;
         if(_loc2_ !== param1)
         {
            this._1777436607_TDMResultWindowAccordionContentListRenderer_SetStyle2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetStyle3() : SetStyle
      {
         return this._1777436606_TDMResultWindowAccordionContentListRenderer_SetStyle3;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetStyle3(param1:SetStyle) : void
      {
         var _loc2_:Object = this._1777436606_TDMResultWindowAccordionContentListRenderer_SetStyle3;
         if(_loc2_ !== param1)
         {
            this._1777436606_TDMResultWindowAccordionContentListRenderer_SetStyle3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetStyle4() : SetStyle
      {
         return this._1777436605_TDMResultWindowAccordionContentListRenderer_SetStyle4;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetStyle4(param1:SetStyle) : void
      {
         var _loc2_:Object = this._1777436605_TDMResultWindowAccordionContentListRenderer_SetStyle4;
         if(_loc2_ !== param1)
         {
            this._1777436605_TDMResultWindowAccordionContentListRenderer_SetStyle4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetStyle5() : SetStyle
      {
         return this._1777436604_TDMResultWindowAccordionContentListRenderer_SetStyle5;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetStyle5(param1:SetStyle) : void
      {
         var _loc2_:Object = this._1777436604_TDMResultWindowAccordionContentListRenderer_SetStyle5;
         if(_loc2_ !== param1)
         {
            this._1777436604_TDMResultWindowAccordionContentListRenderer_SetStyle5 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle5",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMResultWindowAccordionContentListRenderer_SetStyle6() : SetStyle
      {
         return this._1777436603_TDMResultWindowAccordionContentListRenderer_SetStyle6;
      }
      
      public function set _TDMResultWindowAccordionContentListRenderer_SetStyle6(param1:SetStyle) : void
      {
         var _loc2_:Object = this._1777436603_TDMResultWindowAccordionContentListRenderer_SetStyle6;
         if(_loc2_ !== param1)
         {
            this._1777436603_TDMResultWindowAccordionContentListRenderer_SetStyle6 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMResultWindowAccordionContentListRenderer_SetStyle6",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : spark.components.Group
      {
         return this._951530617content;
      }
      
      public function set content(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get killDeath() : TDMAccordionContent
      {
         return this._1588604490killDeath;
      }
      
      public function set killDeath(param1:TDMAccordionContent) : void
      {
         var _loc2_:Object = this._1588604490killDeath;
         if(_loc2_ !== param1)
         {
            this._1588604490killDeath = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"killDeath",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get peakDMG() : TDMAccordionContent
      {
         return this._694421601peakDMG;
      }
      
      public function set peakDMG(param1:TDMAccordionContent) : void
      {
         var _loc2_:Object = this._694421601peakDMG;
         if(_loc2_ !== param1)
         {
            this._694421601peakDMG = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"peakDMG",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pointDelta() : TDMAccordionContent
      {
         return this._1240887304pointDelta;
      }
      
      public function set pointDelta(param1:TDMAccordionContent) : void
      {
         var _loc2_:Object = this._1240887304pointDelta;
         if(_loc2_ !== param1)
         {
            this._1240887304pointDelta = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointDelta",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topLable() : Label
      {
         return this._984130703topLable;
      }
      
      public function set topLable(param1:Label) : void
      {
         var _loc2_:Object = this._984130703topLable;
         if(_loc2_ !== param1)
         {
            this._984130703topLable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topLable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topLablePointsDelta() : Label
      {
         return this._2145619868topLablePointsDelta;
      }
      
      public function set topLablePointsDelta(param1:Label) : void
      {
         var _loc2_:Object = this._2145619868topLablePointsDelta;
         if(_loc2_ !== param1)
         {
            this._2145619868topLablePointsDelta = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topLablePointsDelta",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalDMGgiven() : TDMAccordionContent
      {
         return this._36822877totalDMGgiven;
      }
      
      public function set totalDMGgiven(param1:TDMAccordionContent) : void
      {
         var _loc2_:Object = this._36822877totalDMGgiven;
         if(_loc2_ !== param1)
         {
            this._36822877totalDMGgiven = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalDMGgiven",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalDMGtaken() : TDMAccordionContent
      {
         return this._25066003totalDMGtaken;
      }
      
      public function set totalDMGtaken(param1:TDMAccordionContent) : void
      {
         var _loc2_:Object = this._25066003totalDMGtaken;
         if(_loc2_ !== param1)
         {
            this._25066003totalDMGtaken = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalDMGtaken",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winnigStreak() : TDMAccordionContent
      {
         return this._896599986winnigStreak;
      }
      
      public function set winnigStreak(param1:TDMAccordionContent) : void
      {
         var _loc2_:Object = this._896599986winnigStreak;
         if(_loc2_ !== param1)
         {
            this._896599986winnigStreak = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winnigStreak",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      override public function set data(param1:Object) : void
      {
         var _loc2_:Object = this.data;
         if(_loc2_ !== param1)
         {
            this._3076010data = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"data",_loc2_,param1));
            }
         }
      }
   }
}

