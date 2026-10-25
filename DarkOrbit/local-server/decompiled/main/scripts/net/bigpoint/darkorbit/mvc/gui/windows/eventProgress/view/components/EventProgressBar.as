package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.components
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.displayobject.DisplayObjectActivator;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemPackageLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo.EventRewardVO;
   
   public class EventProgressBar extends Coreponent
   {
      
      private static const DEFAULT_LIBRARY:String = "eventProgressUI";
      
      private static const THIS_IS_MAGIC:Number = 0.2;
      
      private var _library:String;
      
      private var outlineLayer:Sprite = new Sprite();
      
      private var maskLayer:Sprite = new Sprite();
      
      private var progressLayer:Sprite = new Sprite();
      
      private var selectionLayer:Sprite = new Sprite();
      
      private var itemsLayer:Sprite = new Sprite();
      
      private var outlinedNodeSegmentDrawer:IDrawFragment = new OutlineNodeSegment();
      
      private var maskedNodeSegmentDrawer:IDrawFragment = new MaskNodeSegment();
      
      private var selectionNodeSegmentDrawer:IDrawFragment = new SelectionNodeSegment();
      
      private var _invalidItemList:Boolean = false;
      
      private var _isProgressInvalidate:Boolean = false;
      
      private var _isUpdateCollectedStatusInvalidate:Boolean = false;
      
      private var _updateCollectedStatus:int = -1;
      
      private var _itemsAmount:uint = 1;
      
      private var _items:Vector.<EventRewardVO>;
      
      private var _percentagePerSegement:Number;
      
      private var _nodeSegmentHeight:uint = 66;
      
      private var _nodeSegmentWidth:uint = 66;
      
      private var DEFAULT_PROGRESS_FILLCOLOR:Number = 559273;
      
      private var drawIndexToFillMethodList:Dictionary;
      
      private const drawConnectorStructureList:Vector.<DrawConnectorStructure> = new Vector.<DrawConnectorStructure>();
      
      private var eventProgressConnecturStructureList:Vector.<DrawConnectorStructure>;
      
      private var _progressAbsolute:Number;
      
      private var _absoluteNextReward:Number;
      
      public function EventProgressBar()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.addLayers();
         this.prepareDrawIndexToFillMethodList();
         this.prepareConnectorStructure();
      }
      
      private function prepareDrawIndexToFillMethodList() : void
      {
         FillProgress.fillColor = this.DEFAULT_PROGRESS_FILLCOLOR;
         this.drawIndexToFillMethodList = new Dictionary();
         this.drawIndexToFillMethodList[0] = FillProgress.fill0;
         this.drawIndexToFillMethodList[1] = FillProgress.fill1;
         this.drawIndexToFillMethodList[2] = FillProgress.fill2;
         this.drawIndexToFillMethodList[3] = FillProgress.fill3;
         this.drawIndexToFillMethodList[DrawConnectorStructure.ODD_FINAL_NODE_TOP_INDEX] = FillProgress.fill8;
         this.drawIndexToFillMethodList[DrawConnectorStructure.ODD_FINAL_NODE_BOTTOM_INDEX] = FillProgress.fill8;
      }
      
      private function prepareConnectorStructure() : void
      {
         this.drawConnectorStructureList.length = 0;
         this.drawConnectorStructureList.push(new DrawConnectorStructure(DEFAULT_LIBRARY));
         this.drawConnectorStructureList.push(new DrawConnectorStructure(DEFAULT_LIBRARY));
         this.drawConnectorStructureList.push(new DrawConnectorStructure(DEFAULT_LIBRARY));
         this.drawConnectorStructureList.push(new DrawConnectorStructure(DEFAULT_LIBRARY));
         this.library = DEFAULT_LIBRARY;
      }
      
      protected function addLayers() : void
      {
         if(!this.contains(this.outlineLayer))
         {
            addChild(this.outlineLayer);
         }
         if(!this.contains(this.maskLayer))
         {
            addChild(this.maskLayer);
         }
         if(!this.contains(this.selectionLayer))
         {
            addChild(this.selectionLayer);
         }
         if(!this.contains(this.progressLayer))
         {
            addChild(this.progressLayer);
         }
         if(!this.contains(this.itemsLayer))
         {
            addChild(this.itemsLayer);
         }
      }
      
      protected function removeLayers() : void
      {
         if(this.contains(this.outlineLayer))
         {
            removeChild(this.outlineLayer);
         }
         if(this.contains(this.maskLayer))
         {
            removeChild(this.maskLayer);
         }
         if(this.contains(this.selectionLayer))
         {
            removeChild(this.selectionLayer);
         }
         if(this.contains(this.progressLayer))
         {
            removeChild(this.progressLayer);
         }
         if(this.contains(this.itemsLayer))
         {
            removeChild(this.itemsLayer);
         }
      }
      
      protected function removeLayerChildren() : void
      {
         this.outlineLayer.removeChildren();
         this.maskLayer.removeChildren();
         this.progressLayer.removeChildren();
         this.itemsLayer.removeChildren();
         this.selectionLayer.removeChildren();
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(this._invalidItemList)
         {
            this._invalidItemList = false;
            this.__drawEventProgressSegments();
            this.__addFinalRewardToolTip();
         }
         if(this._isProgressInvalidate)
         {
            this._isProgressInvalidate = false;
            this.__updateProgress();
         }
         if(this._isUpdateCollectedStatusInvalidate)
         {
            this._isUpdateCollectedStatusInvalidate = false;
            this.__updateCollectedStatus();
         }
      }
      
      public function set list(param1:Vector.<EventRewardVO>) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this._items != param1)
         {
            this._items = param1;
            this._itemsAmount = param1.length;
            this._percentagePerSegement = 1 / this._itemsAmount;
            this._invalidItemList = true;
            this.addEventListener(Event.ENTER_FRAME,updateNow);
         }
      }
      
      public function set updateCollectedStatus(param1:int) : void
      {
         this._updateCollectedStatus = param1;
         this._isUpdateCollectedStatusInvalidate = true;
         this.addEventListener(Event.ENTER_FRAME,updateNow);
      }
      
      public function updateProgress(param1:Number) : void
      {
         this._isProgressInvalidate = true;
         this._progressAbsolute = param1;
         this.addEventListener(Event.ENTER_FRAME,updateNow);
      }
      
      protected function __drawEventProgressSegments() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:ItemLoader = null;
         var _loc9_:uint = 0;
         var _loc11_:DrawConnectorStructure = null;
         var _loc13_:String = null;
         var _loc14_:EventRewardVO = null;
         var _loc15_:ItemVO = null;
         var _loc16_:Array = null;
         var _loc17_:ItemPackageLoader = null;
         this.removeLayerChildren();
         var _loc1_:DrawConnectorStructure = new DrawConnectorStructure(DEFAULT_LIBRARY);
         _loc1_.index = DrawConnectorStructure.START_NODE_INDEX;
         var _loc2_:DisplayObject = this.outlinedNodeSegmentDrawer.create(_loc1_);
         this.outlineLayer.addChild(_loc2_);
         this.eventProgressConnecturStructureList = new Vector.<DrawConnectorStructure>();
         var _loc7_:uint = 0;
         var _loc8_:uint = this._itemsAmount - 1;
         var _loc10_:uint = 0;
         var _loc12_:uint = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc12_ = _loc7_ % this.drawConnectorStructureList.length;
            _loc11_ = this.drawConnectorStructureList[_loc12_].clone();
            _loc11_.index = _loc12_;
            if(_loc7_ == _loc8_ - 1)
            {
               if(_loc12_ == 2)
               {
                  _loc11_.index = DrawConnectorStructure.ODD_FINAL_NODE_BOTTOM_INDEX;
               }
               else if(_loc12_ == 0)
               {
                  _loc11_.index = DrawConnectorStructure.ODD_FINAL_NODE_TOP_INDEX;
               }
            }
            this.eventProgressConnecturStructureList.push(_loc11_);
            _loc9_ = this.calcXPos(_loc7_);
            _loc10_ = this.calcYPos(_loc7_);
            _loc3_ = this.outlinedNodeSegmentDrawer.create(_loc11_);
            _loc3_.x = _loc9_;
            _loc3_.y = _loc10_;
            this.outlineLayer.addChild(_loc3_);
            _loc5_ = this.maskedNodeSegmentDrawer.create(_loc11_);
            _loc5_.x = _loc9_;
            _loc5_.y = _loc10_;
            this.maskLayer.addChild(_loc5_);
            _loc4_ = this.selectionNodeSegmentDrawer.create(_loc11_);
            _loc4_.x = _loc9_;
            _loc4_.y = _loc10_;
            _loc4_.visible = false;
            this.selectionLayer.addChild(_loc4_);
            this.progressLayer.addChild(new Sprite());
            _loc13_ = "";
            _loc14_ = this._items[_loc7_];
            if(_loc14_.lootID)
            {
               _loc6_ = new ItemLoader(_loc14_.lootID);
               _loc6_.x = _loc9_ + 18;
               _loc6_.y = _loc10_ + 18;
               _loc15_ = ItemDataProviderHelper.getItem(_loc14_.lootID);
               if(_loc15_.fullname)
               {
                  _loc13_ += _loc15_.fullname + "\n";
               }
               if(_loc15_.rawDescription)
               {
                  _loc13_ += _loc15_.rawDescription + "\n";
               }
               if(_loc14_.amount > 0)
               {
                  _loc13_ += BPLocale.getItem("tdm_result_window_ttip_amount_headline") + ": " + _loc14_.amount + "\n";
               }
               this.addItemToolTip(_loc6_,_loc13_);
               this.itemsLayer.addChild(_loc6_);
            }
            else if(_loc14_.packageID)
            {
               _loc16_ = _loc14_.getPackageItemIDs();
               if(_loc16_)
               {
                  if(_loc16_.length > 0)
                  {
                     _loc17_ = new ItemPackageLoader();
                     _loc17_.itemShowTimeInSec = _loc14_.itemShowTimeInMS;
                     _loc17_.width = 32;
                     _loc17_.height = 32;
                     _loc17_.x = _loc9_ + 18;
                     _loc17_.y = _loc10_ + 18;
                     _loc17_.list = _loc16_;
                     if(_loc14_.tooltipkey)
                     {
                        TooltipControl.getInstance().addToolTip(_loc17_,BPLocale.getItem(_loc14_.tooltipkey));
                     }
                     this.itemsLayer.addChild(_loc17_);
                  }
               }
            }
            _loc7_++;
         }
         this.progressLayer.cacheAsBitmap = true;
         this.maskLayer.cacheAsBitmap = true;
         this.progressLayer.mask = this.maskLayer;
      }
      
      protected function addItemToolTip(param1:InteractiveObject, param2:String) : void
      {
         TooltipControl.getInstance().addToolTip(param1,param2);
      }
      
      protected function __addFinalRewardToolTip() : void
      {
         var _loc4_:ItemVO = null;
         var _loc5_:Array = null;
         var _loc1_:String = "";
         var _loc2_:EventRewardVO = this._items[this._itemsAmount - 1];
         if(_loc2_.lootID)
         {
            _loc4_ = ItemDataProviderHelper.getItem(_loc2_.lootID);
            if(_loc4_.fullname)
            {
               _loc1_ += _loc4_.fullname + "\n";
            }
            if(_loc4_.rawDescription)
            {
               _loc1_ += _loc4_.rawDescription + "\n";
            }
            if(_loc2_.amount > 0)
            {
               _loc1_ += BPLocale.getItem("tdm_result_window_ttip_amount_headline") + ": " + _loc2_.amount + "\n";
            }
         }
         else if(_loc2_.packageID)
         {
            _loc5_ = _loc2_.getPackageItemIDs();
            if(_loc5_)
            {
               if(_loc5_.length > 0)
               {
                  _loc1_ = BPLocale.getItem(_loc2_.tooltipkey);
               }
            }
         }
         var _loc3_:EventProgressBarEvent = new EventProgressBarEvent(EventProgressBarEvent.EVENT_UPDATE_FINAL_REWARD_TOOLTIP).setFinalRewardTooltip(_loc1_);
         dispatchEvent(_loc3_);
      }
      
      private function calcXPos(param1:uint) : Number
      {
         var _loc2_:Number = 1 + (param1 >> 1);
         return this._nodeSegmentWidth * _loc2_;
      }
      
      private function calcYPos(param1:uint) : Number
      {
         var _loc2_:Number = (param1 & 3) == 1 || (param1 & 3) == 2 ? 1 : 0;
         return this._nodeSegmentHeight * _loc2_;
      }
      
      protected function __updateProgress() : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:EventRewardVO = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(!this._items)
         {
            return;
         }
         this._itemsAmount = this._items.length;
         var _loc1_:uint = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 1 / this._itemsAmount;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < this._itemsAmount)
         {
            _loc7_ = this._items[_loc1_];
            _loc4_ = _loc7_.unlockRequirement;
            if(this._progressAbsolute < _loc4_ || this._progressAbsolute == _loc4_ && _loc1_ == this._itemsAmount - 1)
            {
               _loc8_ = this._progressAbsolute - _loc5_;
               _loc9_ = _loc4_ - _loc5_;
               _loc6_ = _loc8_ / _loc9_;
               _loc2_ += _loc6_ / this._itemsAmount;
               break;
            }
            _loc2_ += _loc3_;
            _loc5_ = _loc4_;
            _loc1_++;
         }
         this._absoluteNextReward = _loc7_.unlockRequirement;
         this._updateSegementProgress(_loc2_);
         if(_loc1_ >= this._itemsAmount - 1)
         {
            this._updateFinalRewardItem(_loc6_);
         }
         else
         {
            this._updateFinalRewardItem(0);
         }
      }
      
      private function _updateSegementProgress(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         if(param1 >= 0 && param1 <= 1)
         {
            _loc2_ = THIS_IS_MAGIC * this._percentagePerSegement;
            param1 -= _loc2_;
            param1 = param1 < 0 ? 0 : param1;
            _loc3_ = 1 / this._itemsAmount;
            _loc4_ = Math.floor(param1 / _loc3_);
            _loc5_ = (param1 - _loc4_ * _loc3_) * this._itemsAmount;
            _loc6_ = 0;
            while(_loc6_ < this._itemsAmount)
            {
               if(_loc6_ < _loc4_)
               {
                  this.fillSegmentProgress(1,_loc6_);
               }
               else if(_loc6_ == _loc4_)
               {
                  this.fillSegmentProgress(_loc5_,_loc6_);
               }
               else if(_loc6_ > _loc4_)
               {
                  this.fillSegmentProgress(0,_loc6_);
               }
               _loc6_++;
            }
            return;
         }
         throw new Error("Something went wrong with the Component::updateProgress method.");
      }
      
      private function _updateFinalRewardItem(param1:Number) : void
      {
         var _loc4_:Number = NaN;
         if(param1 > 0)
         {
            _loc4_ = THIS_IS_MAGIC;
            param1 -= _loc4_;
            param1 = param1 < 0 ? 0 : param1;
            param1 *= 1 / (1 - _loc4_);
         }
         param1 = param1 > 1 ? 1 : param1;
         var _loc2_:Boolean = param1 == 1 ? true : false;
         var _loc3_:EventProgressBarEvent = new EventProgressBarEvent(EventProgressBarEvent.EVENT_UPDATE_REWARD_PROGRESS).setProgress(param1).setSelection(_loc2_).setAbsoluteProgress(this._progressAbsolute).setNextRewardAbsolute(this._absoluteNextReward);
         dispatchEvent(_loc3_);
      }
      
      private function _selectEventItem(param1:uint, param2:Boolean = false) : void
      {
         if(param1 >= this.selectionLayer.numChildren)
         {
            return;
         }
         var _loc3_:DisplayObject = this.selectionLayer.getChildAt(param1);
         _loc3_.visible = param2;
      }
      
      private function fillSegmentProgress(param1:Number, param2:uint) : void
      {
         var _loc7_:DrawConnectorStructure = null;
         var _loc8_:uint = 0;
         var _loc9_:Function = null;
         if(param2 >= this.progressLayer.numChildren)
         {
            return;
         }
         var _loc3_:Sprite = this.progressLayer.getChildAt(param2) as Sprite;
         var _loc4_:Graphics = _loc3_.graphics;
         _loc4_.clear();
         var _loc5_:Number = this.calcXPos(param2);
         var _loc6_:Number = this.calcYPos(param2);
         if(this.eventProgressConnecturStructureList)
         {
            _loc7_ = this.eventProgressConnecturStructureList[param2];
            _loc8_ = uint(_loc7_.index);
            _loc9_ = this.drawIndexToFillMethodList[_loc8_];
            _loc9_(_loc3_,param1);
            _loc3_.x = _loc5_;
            _loc3_.y = _loc6_;
         }
      }
      
      public function set library(param1:String) : void
      {
         var _loc2_:DrawConnectorStructure = null;
         this._library = param1;
         for each(_loc2_ in this.drawConnectorStructureList)
         {
            _loc2_.library = param1;
         }
      }
      
      private function __updateCollectedStatus() : void
      {
         if(!this._items)
         {
            return;
         }
         var _loc1_:Boolean = false;
         var _loc2_:uint = 0;
         while(_loc2_ < this._itemsAmount)
         {
            if(_loc2_ < this._updateCollectedStatus)
            {
               this.colorizeIconInSegment(_loc2_,true);
               this._selectEventItem(_loc2_,false);
            }
            else if(this._items[_loc2_].unlockRequirement <= this._progressAbsolute)
            {
               this.colorizeIconInSegment(_loc2_,true);
               this._selectEventItem(_loc2_,true);
               _loc1_ = true;
            }
            else
            {
               this.colorizeIconInSegment(_loc2_,false);
               this._selectEventItem(_loc2_,false);
            }
            _loc2_++;
         }
         var _loc3_:Boolean = this._items[this._items.length - 1].unlockRequirement == this._progressAbsolute;
         dispatchEvent(new EventProgressBarEvent(EventProgressBarEvent.EVENT_COLLECTABLE_ITEM_AVAILABLE).setCollectableItemAvailable(_loc1_).setMaxProgressReached(_loc3_));
      }
      
      protected function colorizeIconInSegment(param1:uint, param2:Boolean) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Object = null;
         if(this.itemsLayer)
         {
            if(param1 >= this.itemsLayer.numChildren)
            {
               return;
            }
            _loc3_ = this.itemsLayer.getChildAt(param1) as Sprite;
            if(_loc3_)
            {
               if(param2)
               {
                  _loc4_ = DisplayObjectActivator.TWEENMAX_COLORMATRIX_COLORED;
               }
               else
               {
                  _loc4_ = DisplayObjectActivator.TWEENMAX_COLORMATRIX_BLACKANDWHITE;
               }
               TweenMax.to(_loc3_,0.3,_loc4_);
            }
         }
      }
   }
}

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import net.bigpoint.darkorbit.managers.ResourceManager;

class DrawConnectorStructure
{
   
   public static var ODD_FINAL_NODE_BOTTOM_INDEX:uint = 7;
   
   public static var ODD_FINAL_NODE_TOP_INDEX:uint = 8;
   
   public static var START_NODE_INDEX:uint = 9;
   
   private var _library:String;
   
   public var drawTarget:DisplayObject;
   
   public var index:int = -1;
   
   public function DrawConnectorStructure(param1:String = null)
   {
      super();
      if(param1)
      {
         this._library = param1;
      }
   }
   
   public function clone() : DrawConnectorStructure
   {
      var _loc1_:DrawConnectorStructure = new DrawConnectorStructure();
      _loc1_.library = this._library;
      return _loc1_;
   }
   
   public function set library(param1:String) : void
   {
      this._library = param1;
   }
   
   public function get library() : String
   {
      return this._library;
   }
}

interface IDrawFragment
{
   
   function create(param1:DrawConnectorStructure) : DisplayObject;
}

class AbstractDrawFragment implements IDrawFragment
{
   
   protected var fragment:DisplayObject;
   
   protected var drawStructure:DrawConnectorStructure;
   
   public function AbstractDrawFragment()
   {
      super();
   }
   
   public function create(param1:DrawConnectorStructure) : DisplayObject
   {
      this.drawStructure = param1;
      return null;
   }
   
   protected function get PRE() : String
   {
      return "win_event_segment";
   }
   
   protected function get POST() : String
   {
      throw new Error("You tried to invoke an abstract method = {POST}");
   }
   
   protected function get libraryID() : String
   {
      return this.PRE + this.drawStructure.index + this.POST;
   }
   
   protected function createSegment(param1:String) : Bitmap
   {
      return ResourceManager.getBitmap(this.drawStructure.library,param1);
   }
}

class OutlineNodeSegment extends AbstractDrawFragment implements IDrawFragment
{
   
   public function OutlineNodeSegment()
   {
      super();
   }
   
   override public function create(param1:DrawConnectorStructure) : DisplayObject
   {
      super.create(param1);
      fragment = createSegment(libraryID);
      return fragment;
   }
   
   override protected function get POST() : String
   {
      return "_outline";
   }
}

class SelectionNodeSegment extends AbstractDrawFragment implements IDrawFragment
{
   
   public function SelectionNodeSegment()
   {
      super();
   }
   
   override public function create(param1:DrawConnectorStructure) : DisplayObject
   {
      super.create(param1);
      fragment = createSegment(libraryID);
      return fragment;
   }
   
   override protected function get POST() : String
   {
      return "_selection";
   }
}

class MaskNodeSegment extends AbstractDrawFragment implements IDrawFragment
{
   
   public function MaskNodeSegment()
   {
      super();
   }
   
   override public function create(param1:DrawConnectorStructure) : DisplayObject
   {
      super.create(param1);
      fragment = createSegment(libraryID);
      return fragment;
   }
   
   override protected function get POST() : String
   {
      return "_mask";
   }
}

class FillProgress
{
   
   public static var fillBlockSize:uint = 15;
   
   public static var fillSegmentSize:uint = 36;
   
   public static var fillColor:Number = 16711680;
   
   private static const limit1:Number = 0.21;
   
   private static const limit2:Number = 1 - limit1;
   
   public function FillProgress()
   {
      super();
   }
   
   public static function fill0(param1:Sprite, param2:Number) : void
   {
      var _loc4_:Number = NaN;
      var _loc3_:Object = splitSegmentPercentageValue(param2);
      var _loc5_:Graphics = param1.graphics;
      _loc5_.clear();
      _loc4_ = fillBlockSize * _loc3_.p1;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(0,fillBlockSize,_loc4_,fillSegmentSize);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc6_:Number = _loc4_ >= 0.5 ? 1 : _loc4_ * 2;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize * _loc6_,fillBlockSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc7_:Number = _loc4_ >= 0.5 ? (_loc4_ - 0.5) * 2 : 0;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize + fillSegmentSize * _loc7_);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.endFill();
      _loc4_ = fillBlockSize * _loc3_.p3;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(fillBlockSize,fillBlockSize + fillSegmentSize,fillSegmentSize,_loc4_);
      _loc5_.endFill();
   }
   
   public static function fill1(param1:Sprite, param2:Number) : void
   {
      var _loc4_:Number = NaN;
      var _loc3_:Object = splitSegmentPercentageValue(param2);
      var _loc5_:Graphics = param1.graphics;
      _loc5_.clear();
      _loc4_ = fillBlockSize * _loc3_.p1;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(fillBlockSize,0,fillSegmentSize,_loc4_);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc6_:Number = _loc4_ >= 0.5 ? 1 : _loc4_ * 2;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize * _loc6_);
      _loc5_.lineTo(fillBlockSize,fillBlockSize);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc7_:Number = _loc4_ >= 0.5 ? (_loc4_ - 0.5) * 2 : 0;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize + fillSegmentSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize * _loc7_,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize);
      _loc5_.endFill();
      _loc4_ = fillBlockSize * _loc3_.p3;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(fillBlockSize + fillSegmentSize,fillBlockSize,_loc4_,fillSegmentSize);
      _loc5_.endFill();
   }
   
   public static function fill2(param1:Sprite, param2:Number) : void
   {
      var _loc4_:Number = NaN;
      var _loc3_:Object = splitSegmentPercentageValue(param2);
      var _loc5_:Graphics = param1.graphics;
      _loc5_.clear();
      _loc4_ = fillBlockSize * _loc3_.p1;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(0,fillBlockSize,_loc4_,fillSegmentSize);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc6_:Number = _loc4_ >= 0.5 ? 1 : _loc4_ * 2;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize * _loc6_,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc7_:Number = _loc4_ >= 0.5 ? (_loc4_ - 0.5) * 2 : 0;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize + fillSegmentSize - fillSegmentSize * _loc7_);
      _loc5_.lineTo(fillBlockSize,fillBlockSize);
      _loc5_.endFill();
      _loc4_ = fillBlockSize * _loc3_.p3;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(fillBlockSize,fillBlockSize,fillSegmentSize,-_loc4_);
      _loc5_.endFill();
   }
   
   public static function fill3(param1:Sprite, param2:Number) : void
   {
      var _loc4_:Number = NaN;
      var _loc3_:Object = splitSegmentPercentageValue(param2);
      var _loc5_:Graphics = param1.graphics;
      _loc5_.clear();
      _loc4_ = fillBlockSize * _loc3_.p1;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(fillBlockSize,(fillBlockSize << 1) + fillSegmentSize,fillSegmentSize,-_loc4_);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc6_:Number = _loc4_ >= 0.5 ? 1 : _loc4_ * 2;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize - fillSegmentSize * _loc6_);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize + fillSegmentSize);
      _loc5_.endFill();
      _loc4_ = Number(_loc3_.p2);
      var _loc7_:Number = _loc4_ >= 0.5 ? (_loc4_ - 0.5) * 2 : 0;
      _loc5_.beginFill(fillColor);
      _loc5_.moveTo(fillBlockSize,fillBlockSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize * _loc7_,fillBlockSize);
      _loc5_.lineTo(fillBlockSize + fillSegmentSize,fillBlockSize + fillSegmentSize);
      _loc5_.lineTo(fillBlockSize,fillBlockSize);
      _loc5_.endFill();
      _loc4_ = fillBlockSize * _loc3_.p3;
      _loc5_.beginFill(fillColor);
      _loc5_.drawRect(fillBlockSize + fillSegmentSize,fillBlockSize,_loc4_,fillSegmentSize);
      _loc5_.endFill();
   }
   
   public static function fill8(param1:Sprite, param2:Number) : void
   {
      var _loc3_:Graphics = param1.graphics;
      var _loc4_:Number = param2 * ((fillBlockSize << 1) + fillSegmentSize);
      _loc3_.clear();
      _loc3_.beginFill(fillColor);
      _loc3_.drawRect(0,fillBlockSize,_loc4_,fillSegmentSize);
      _loc3_.endFill();
   }
   
   private static function splitSegmentPercentageValue(param1:Number) : Object
   {
      var _loc2_:Number = 0;
      if(param1 <= limit1)
      {
         _loc2_ = param1 / limit1;
      }
      else
      {
         _loc2_ = 1;
      }
      var _loc3_:Number = 0;
      if(param1 > limit1 && param1 < limit2)
      {
         _loc3_ = (param1 - limit1) / (limit2 - limit1);
      }
      else if(param1 >= limit2)
      {
         _loc3_ = 1;
      }
      var _loc4_:Number = 0;
      if(param1 >= limit2)
      {
         _loc4_ = (param1 - limit2) / limit1;
      }
      else if(param1 >= 0.999)
      {
         _loc4_ = 1;
      }
      return {
         "p1":_loc2_,
         "p2":_loc3_,
         "p3":_loc4_
      };
   }
}
