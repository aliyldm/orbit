package net.bigpoint.darkorbit.mvc.companyhierarchy.view.components
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
   import mx.binding.*;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.filters.*;
   import mx.managers.ToolTipManager;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo.IRankedClanViewData;
   import spark.components.BorderContainer;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class RankedClanItem extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1337942823backgroundImageHolder:BorderContainer;
      
      private var _686422535clanDesc:Label;
      
      private var _686716417clanName:Label;
      
      private var _948335552companyPoints:Label;
      
      private var _1190988602leaderDesc:Label;
      
      private var _1191282484leaderName:Label;
      
      private var _392635643posDesc:Label;
      
      private var _747804969position:Label;
      
      private var _249489888ptsDesc:Label;
      
      private var _3492908rank:Label;
      
      private var _1738094273rankedClan:HGroup;
      
      private var _154246926rankedClanDesc:BorderContainer;
      
      private var _481848550rankedClanImage:BitmapImage;
      
      private var _922138247rankedClanImageContainer:BorderContainer;
      
      private var _479434573rankedClanLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _rankedClanVO:IRankedClanViewData;
      
      private var _loadingCompleted:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RankedClanItem()
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
         bindings = this._RankedClanItem_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_companyhierarchy_view_components_RankedClanItemWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return RankedClanItem[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._RankedClanItem_Array1_c);
         this.addEventListener("creationComplete",this.___RankedClanItem_SkinnableContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RankedClanItem._watcherSetupUtil = param1;
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
      
      public function set rankedClanVO(param1:IRankedClanViewData) : void
      {
         this._rankedClanVO = param1;
         this.updateValues();
      }
      
      private function onComplete() : void
      {
         var _loc1_:Bitmap = null;
         if(ResourceManager.fileCollection.getFinisher("clanHierarchyWin") != null && Boolean((ResourceManager.fileCollection.getFinisher("clanHierarchyWin") as SWFFinisher).getEmbeddedObject("rankedItemBg")))
         {
            _loc1_ = ResourceManager.getBitmap("clanHierarchyWin","rankedItemBg");
            this.backgroundImageHolder.setStyle("backgroundImage",_loc1_);
         }
         this._loadingCompleted = true;
         this.posDesc.text = BPLocale.getItem("company_hierarchy_desc_position");
         this.clanDesc.text = BPLocale.getItem("company_hierarchy_desc_clan");
         this.leaderDesc.text = BPLocale.getItem("company_hierarchy_desc_leader");
         this.ptsDesc.text = BPLocale.getItem("company_hierarchy_desc_points");
         this.updateValues();
      }
      
      private function onLogoLoaded(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:Loader = new Loader();
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadedLogoConvertedLogo);
         _loc3_.loadBytes(_loc2_.data as ByteArray);
      }
      
      private function onLoadedLogoConvertedLogo(param1:Event) : void
      {
         var _loc2_:Bitmap = LoaderInfo(param1.currentTarget).content as Bitmap;
         var _loc3_:Number = (this.rankedClanImageContainer.width - 2) / _loc2_.width;
         var _loc4_:Number = (this.rankedClanImageContainer.height - 2) / _loc2_.height;
         this.rankedClanImage.source = _loc2_;
         this.rankedClanImage.scaleX = _loc3_;
         this.rankedClanImage.scaleY = _loc4_;
      }
      
      private function onLoadFailed(param1:Event) : void
      {
      }
      
      private function updateValues() : void
      {
         var clanBgImg:Bitmap = null;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var rcHighlightHolder:UIComponent = null;
         if(this._loadingCompleted == true && this._rankedClanVO != null)
         {
            if(this._rankedClanVO.logoURL == null || this.rankedClanImage.source == null)
            {
               try
               {
                  clanBgImg = ResourceManager.getBitmap("clanHierarchyWin","clanBg");
                  this.rankedClanImage.source = clanBgImg;
               }
               catch(err:Error)
               {
               }
            }
            if(this._rankedClanVO.logoURL != null)
            {
               request = new URLRequest(this._rankedClanVO.logoURL);
               loader = new URLLoader();
               loader.dataFormat = URLLoaderDataFormat.BINARY;
               loader.addEventListener(Event.COMPLETE,this.onLogoLoaded);
               loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
               loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadFailed);
               loader.load(request);
            }
            this.rank.text = "" + this._rankedClanVO.rank;
            this.rank.toolTip = this.rank.text;
            if(this._rankedClanVO.rank == 1 && this.backgroundImageHolder.numElements <= 2)
            {
               rcHighlightHolder = new UIComponent();
               rcHighlightHolder.addChild(ResourceManager.getMovieClip("clanHierarchyWin","leadingClanFrameHighlight"));
               this.backgroundImageHolder.addElementAt(rcHighlightHolder,1);
            }
            this.position.text = this._rankedClanVO.position;
            this.position.toolTip = this.position.text;
            this.clanName.text = this._rankedClanVO.clan;
            this.clanName.toolTip = this.clanName.text;
            this.rankedClanImageContainer.toolTip = this._rankedClanVO.clan;
            this.leaderName.text = this._rankedClanVO.leader;
            this.leaderName.toolTip = this.leaderName.text;
            this.companyPoints.text = "" + this._rankedClanVO.points;
            this.companyPoints.toolTip = this.companyPoints.text;
            if(this._rankedClanVO.rank > 9)
            {
               this.rank.width = 40 + (this.rank.text.length - 1) * 15;
               this.rankedClan.paddingLeft = -0.5 * this.rank.width;
            }
            this.backgroundImageHolder.toolTip = this._rankedClanVO.cbsNamesAndLocations;
         }
      }
      
      private function toolTipCreateHandler(param1:ToolTipEvent) : void
      {
         ToolTipManager.showDelay = 500;
      }
      
      private function toolTipStartHandler(param1:ToolTipEvent) : void
      {
         ToolTipManager.showDelay = 100;
      }
      
      private function _RankedClanItem_Array1_c() : Array
      {
         return [this._RankedClanItem_HGroup1_i()];
      }
      
      private function _RankedClanItem_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.top = 5;
         _loc1_.bottom = 5;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.mxmlContent = [this._RankedClanItem_Label1_i(),this._RankedClanItem_BorderContainer1_i()];
         _loc1_.id = "rankedClan";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rankedClan = _loc1_;
         BindingManager.executeBindings(this,"rankedClan",this.rankedClan);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "1";
         _loc1_.width = 40;
         _loc1_.setStyle("fontSize",24);
         _loc1_.setStyle("lineBreak","explicit");
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("paddingRight",5);
         _loc1_.id = "rank";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rank = _loc1_;
         BindingManager.executeBindings(this,"rank",this.rank);
         return _loc1_;
      }
      
      private function _RankedClanItem_BorderContainer1_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.width = 225;
         _loc1_.height = 60;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._RankedClanItem_Array3_c);
         _loc1_.setStyle("borderAlpha",0);
         _loc1_.addEventListener("toolTipCreate",this.__backgroundImageHolder_toolTipCreate);
         _loc1_.addEventListener("toolTipStart",this.__backgroundImageHolder_toolTipStart);
         _loc1_.id = "backgroundImageHolder";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.backgroundImageHolder = _loc1_;
         BindingManager.executeBindings(this,"backgroundImageHolder",this.backgroundImageHolder);
         return _loc1_;
      }
      
      private function _RankedClanItem_Array3_c() : Array
      {
         return [this._RankedClanItem_HGroup2_c(),this._RankedClanItem_HGroup5_c()];
      }
      
      private function _RankedClanItem_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentHeight = 100;
         _loc1_.left = 0;
         _loc1_.paddingLeft = 3;
         _loc1_.paddingTop = 3;
         _loc1_.mxmlContent = [this._RankedClanItem_BorderContainer2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_BorderContainer2_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.width = 52;
         _loc1_.height = 52;
         _loc1_.minHeight = 10;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._RankedClanItem_Array5_c);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.setStyle("borderAlpha",0);
         _loc1_.setStyle("borderColor",16777215);
         _loc1_.id = "rankedClanImageContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rankedClanImageContainer = _loc1_;
         BindingManager.executeBindings(this,"rankedClanImageContainer",this.rankedClanImageContainer);
         return _loc1_;
      }
      
      private function _RankedClanItem_Array5_c() : Array
      {
         return [this._RankedClanItem_HGroup3_c(),this._RankedClanItem_HGroup4_c()];
      }
      
      private function _RankedClanItem_HGroup3_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._RankedClanItem_BitmapImage1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"rankedClanImage");
         this.rankedClanImage = _loc1_;
         BindingManager.executeBindings(this,"rankedClanImage",this.rankedClanImage);
         return _loc1_;
      }
      
      private function _RankedClanItem_HGroup4_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._RankedClanItem_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "rankedClanLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rankedClanLabel = _loc1_;
         BindingManager.executeBindings(this,"rankedClanLabel",this.rankedClanLabel);
         return _loc1_;
      }
      
      private function _RankedClanItem_HGroup5_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._RankedClanItem_BorderContainer3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_BorderContainer3_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.percentWidth = 100;
         _loc1_.minWidth = 10;
         _loc1_.minHeight = 10;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._RankedClanItem_Array9_c);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.setStyle("borderAlpha",0);
         _loc1_.setStyle("borderColor",16777215);
         _loc1_.id = "rankedClanDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rankedClanDesc = _loc1_;
         BindingManager.executeBindings(this,"rankedClanDesc",this.rankedClanDesc);
         return _loc1_;
      }
      
      private function _RankedClanItem_Array9_c() : Array
      {
         return [this._RankedClanItem_HGroup6_c()];
      }
      
      private function _RankedClanItem_HGroup6_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.bottom = 8;
         _loc1_.left = 8;
         _loc1_.top = 8;
         _loc1_.right = 8;
         _loc1_.paddingLeft = 60;
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._RankedClanItem_VGroup1_c(),this._RankedClanItem_VGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._RankedClanItem_Label3_i(),this._RankedClanItem_Label4_i(),this._RankedClanItem_Label5_i(),this._RankedClanItem_Label6_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("paddingTop",-5);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "posDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.posDesc = _loc1_;
         BindingManager.executeBindings(this,"posDesc",this.posDesc);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("paddingTop",-4);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "clanDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.clanDesc = _loc1_;
         BindingManager.executeBindings(this,"clanDesc",this.clanDesc);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("paddingTop",-4);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "leaderDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.leaderDesc = _loc1_;
         BindingManager.executeBindings(this,"leaderDesc",this.leaderDesc);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("paddingTop",-4);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "ptsDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ptsDesc = _loc1_;
         BindingManager.executeBindings(this,"ptsDesc",this.ptsDesc);
         return _loc1_;
      }
      
      private function _RankedClanItem_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._RankedClanItem_Label7_i(),this._RankedClanItem_Label8_i(),this._RankedClanItem_Label9_i(),this._RankedClanItem_Label10_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedClanItem_Label7_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "title";
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("paddingTop",-5);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("lineBreak","toFit");
         _loc1_.id = "position";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.position = _loc1_;
         BindingManager.executeBindings(this,"position",this.position);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label8_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "clanName";
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("paddingTop",-4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("lineBreak","toFit");
         _loc1_.id = "clanName";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.clanName = _loc1_;
         BindingManager.executeBindings(this,"clanName",this.clanName);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label9_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "leaderName";
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("paddingTop",-4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("lineBreak","toFit");
         _loc1_.id = "leaderName";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.leaderName = _loc1_;
         BindingManager.executeBindings(this,"leaderName",this.leaderName);
         return _loc1_;
      }
      
      private function _RankedClanItem_Label10_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "companyPoints";
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("paddingTop",-4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("lineBreak","toFit");
         _loc1_.id = "companyPoints";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.companyPoints = _loc1_;
         BindingManager.executeBindings(this,"companyPoints",this.companyPoints);
         return _loc1_;
      }
      
      public function __backgroundImageHolder_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.toolTipCreateHandler(param1);
      }
      
      public function __backgroundImageHolder_toolTipStart(param1:ToolTipEvent) : void
      {
         this.toolTipStartHandler(param1);
      }
      
      public function ___RankedClanItem_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _RankedClanItem_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rank.setStyle("fontFamily",param1);
         },"rank.fontFamily");
         result[1] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorBright;
         },function(param1:uint):void
         {
            rank.setStyle("color",param1);
         },"rank.color");
         result[2] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorGreyed;
         },function(param1:uint):void
         {
            posDesc.setStyle("color",param1);
         },"posDesc.color");
         result[3] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            posDesc.setStyle("fontSize",param1);
         },"posDesc.fontSize");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            posDesc.setStyle("fontFamily",param1);
         },"posDesc.fontFamily");
         result[5] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorGreyed;
         },function(param1:uint):void
         {
            clanDesc.setStyle("color",param1);
         },"clanDesc.color");
         result[6] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            clanDesc.setStyle("fontSize",param1);
         },"clanDesc.fontSize");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clanDesc.setStyle("fontFamily",param1);
         },"clanDesc.fontFamily");
         result[8] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorGreyed;
         },function(param1:uint):void
         {
            leaderDesc.setStyle("color",param1);
         },"leaderDesc.color");
         result[9] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            leaderDesc.setStyle("fontSize",param1);
         },"leaderDesc.fontSize");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            leaderDesc.setStyle("fontFamily",param1);
         },"leaderDesc.fontFamily");
         result[11] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorGreyed;
         },function(param1:uint):void
         {
            ptsDesc.setStyle("color",param1);
         },"ptsDesc.color");
         result[12] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            ptsDesc.setStyle("fontSize",param1);
         },"ptsDesc.fontSize");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            ptsDesc.setStyle("fontFamily",param1);
         },"ptsDesc.fontFamily");
         result[14] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorBright;
         },function(param1:uint):void
         {
            position.setStyle("color",param1);
         },"position.color");
         result[15] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            position.setStyle("fontSize",param1);
         },"position.fontSize");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            position.setStyle("fontFamily",param1);
         },"position.fontFamily");
         result[17] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorBright;
         },function(param1:uint):void
         {
            clanName.setStyle("color",param1);
         },"clanName.color");
         result[18] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            clanName.setStyle("fontSize",param1);
         },"clanName.fontSize");
         result[19] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clanName.setStyle("fontFamily",param1);
         },"clanName.fontFamily");
         result[20] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorGreyed;
         },function(param1:uint):void
         {
            leaderName.setStyle("color",param1);
         },"leaderName.color");
         result[21] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            leaderName.setStyle("fontSize",param1);
         },"leaderName.fontSize");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            leaderName.setStyle("fontFamily",param1);
         },"leaderName.fontFamily");
         result[23] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorBright;
         },function(param1:uint):void
         {
            companyPoints.setStyle("color",param1);
         },"companyPoints.color");
         result[24] = new Binding(this,function():Number
         {
            return Styles.companyHierarchyFontHeight;
         },function(param1:Number):void
         {
            companyPoints.setStyle("fontSize",param1);
         },"companyPoints.fontSize");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            companyPoints.setStyle("fontFamily",param1);
         },"companyPoints.fontFamily");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundImageHolder() : BorderContainer
      {
         return this._1337942823backgroundImageHolder;
      }
      
      public function set backgroundImageHolder(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._1337942823backgroundImageHolder;
         if(_loc2_ !== param1)
         {
            this._1337942823backgroundImageHolder = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundImageHolder",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanDesc() : Label
      {
         return this._686422535clanDesc;
      }
      
      public function set clanDesc(param1:Label) : void
      {
         var _loc2_:Object = this._686422535clanDesc;
         if(_loc2_ !== param1)
         {
            this._686422535clanDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanName() : Label
      {
         return this._686716417clanName;
      }
      
      public function set clanName(param1:Label) : void
      {
         var _loc2_:Object = this._686716417clanName;
         if(_loc2_ !== param1)
         {
            this._686716417clanName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get companyPoints() : Label
      {
         return this._948335552companyPoints;
      }
      
      public function set companyPoints(param1:Label) : void
      {
         var _loc2_:Object = this._948335552companyPoints;
         if(_loc2_ !== param1)
         {
            this._948335552companyPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"companyPoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leaderDesc() : Label
      {
         return this._1190988602leaderDesc;
      }
      
      public function set leaderDesc(param1:Label) : void
      {
         var _loc2_:Object = this._1190988602leaderDesc;
         if(_loc2_ !== param1)
         {
            this._1190988602leaderDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaderDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leaderName() : Label
      {
         return this._1191282484leaderName;
      }
      
      public function set leaderName(param1:Label) : void
      {
         var _loc2_:Object = this._1191282484leaderName;
         if(_loc2_ !== param1)
         {
            this._1191282484leaderName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaderName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get posDesc() : Label
      {
         return this._392635643posDesc;
      }
      
      public function set posDesc(param1:Label) : void
      {
         var _loc2_:Object = this._392635643posDesc;
         if(_loc2_ !== param1)
         {
            this._392635643posDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"posDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get position() : Label
      {
         return this._747804969position;
      }
      
      public function set position(param1:Label) : void
      {
         var _loc2_:Object = this._747804969position;
         if(_loc2_ !== param1)
         {
            this._747804969position = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"position",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ptsDesc() : Label
      {
         return this._249489888ptsDesc;
      }
      
      public function set ptsDesc(param1:Label) : void
      {
         var _loc2_:Object = this._249489888ptsDesc;
         if(_loc2_ !== param1)
         {
            this._249489888ptsDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ptsDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rank() : Label
      {
         return this._3492908rank;
      }
      
      public function set rank(param1:Label) : void
      {
         var _loc2_:Object = this._3492908rank;
         if(_loc2_ !== param1)
         {
            this._3492908rank = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rank",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedClan() : HGroup
      {
         return this._1738094273rankedClan;
      }
      
      public function set rankedClan(param1:HGroup) : void
      {
         var _loc2_:Object = this._1738094273rankedClan;
         if(_loc2_ !== param1)
         {
            this._1738094273rankedClan = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedClan",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedClanDesc() : BorderContainer
      {
         return this._154246926rankedClanDesc;
      }
      
      public function set rankedClanDesc(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._154246926rankedClanDesc;
         if(_loc2_ !== param1)
         {
            this._154246926rankedClanDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedClanDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedClanImage() : BitmapImage
      {
         return this._481848550rankedClanImage;
      }
      
      public function set rankedClanImage(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._481848550rankedClanImage;
         if(_loc2_ !== param1)
         {
            this._481848550rankedClanImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedClanImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedClanImageContainer() : BorderContainer
      {
         return this._922138247rankedClanImageContainer;
      }
      
      public function set rankedClanImageContainer(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._922138247rankedClanImageContainer;
         if(_loc2_ !== param1)
         {
            this._922138247rankedClanImageContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedClanImageContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedClanLabel() : Label
      {
         return this._479434573rankedClanLabel;
      }
      
      public function set rankedClanLabel(param1:Label) : void
      {
         var _loc2_:Object = this._479434573rankedClanLabel;
         if(_loc2_ !== param1)
         {
            this._479434573rankedClanLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedClanLabel",_loc2_,param1));
            }
         }
      }
   }
}

