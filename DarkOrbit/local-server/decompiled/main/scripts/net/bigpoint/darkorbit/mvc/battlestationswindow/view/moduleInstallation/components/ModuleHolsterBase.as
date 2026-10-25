package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.components
{
   import com.greensock.TweenMax;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.controls.ProgressBar;
   import mx.core.IUIComponent;
   import mx.events.DragEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.DragManager;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItemBase;
   import spark.components.BorderContainer;
   import spark.components.HGroup;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.primitives.Rect;
   
   public class ModuleHolsterBase extends SkinnableContainer
   {
      
      public static const SINGLE_MODULE_MODE:String = "single";
      
      public static const DOUBLE_MODULE_MODE:String = "double";
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var secondModuleItemType:int;
      
      private var secondModuleItemItemId:int;
      
      private var _581526855singleHolsterBackground:BorderContainer;
      
      private var _2107016784doubleHolsterBackground:BorderContainer;
      
      private var _1227433863modules:HGroup;
      
      private var _870482017moduleItem:ModuleItem;
      
      private var _1289795426backgroundFlash:Rect;
      
      private var _1131509414progressBar:ProgressBar;
      
      private var _29266967healthBar:ProgressBar;
      
      private var _1717220706sheildBar:ProgressBar;
      
      private var _1370780058installedModuleBars:VGroup;
      
      protected var _1809017048_slotId:int;
      
      private var _244953690_slotId2:int;
      
      private var state:String;
      
      private var countdownIntervalMs:Number;
      
      private var timeLeft:int;
      
      private var totalTime:int;
      
      private var progressTimer:Timer;
      
      private var _1617565349_droppingCallback:Function;
      
      private var _917498898_clickCallback:Function;
      
      private var _341156289_rollCallback:Function;
      
      private var _holsterMode:String = "single";
      
      public var secondModuleItem:ModuleItem = new ModuleItem();
      
      public function ModuleHolsterBase()
      {
         super();
      }
      
      public function setProgressBarVisibility(param1:Boolean) : void
      {
         this.progressBar.visible = param1;
      }
      
      public function setShieldAndHitpoints(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.healthBar.setProgress(param1,param2);
         this.sheildBar.setProgress(param3,param4);
      }
      
      public function setModuleState(param1:String) : void
      {
         this.state = param1;
         switch(param1)
         {
            case ModuleItemBase.INSTALLING_STATE:
               this.installedModuleBars.visible = false;
               break;
            case ModuleItemBase.INSTALLED_STATE:
               this.installedModuleBars.visible = true;
         }
      }
      
      private function handleTimerComplete() : void
      {
         this.setProgressBarVisibility(false);
         this.moduleItem.alpha = 0.1;
         TweenMax.to(this.moduleItem,0.8,{
            "alpha":1,
            "onComplete":this.removeBackgroundFlash
         });
         this.progressTimer.stop();
         this.progressTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
      }
      
      private function removeBackgroundFlash() : void
      {
         this.backgroundFlash.alpha = 0;
      }
      
      private function handleTimerTick(param1:TimerEvent) : void
      {
         this.timeLeft -= this.countdownIntervalMs;
         if(this.timeLeft <= 0)
         {
            this.handleTimerComplete();
         }
         this.progressBar.setProgress(this.timeLeft,this.totalTime);
      }
      
      public function get holsterMode() : String
      {
         return this._holsterMode;
      }
      
      public function set holsterMode(param1:String) : void
      {
         this._holsterMode = param1;
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         switch(this._holsterMode)
         {
            case SINGLE_MODULE_MODE:
               this.width = 38;
               if(this.modules.containsElement(this.secondModuleItem))
               {
                  this.modules.removeElement(this.secondModuleItem);
               }
               break;
            case DOUBLE_MODULE_MODE:
               this.width = 69;
               this.moduleItem.addEventListener(MouseEvent.CLICK,this._clickCallback);
               this.moduleItem.addEventListener(DragEvent.DRAG_DROP,this._droppingCallback);
               this.moduleItem.addEventListener(DragEvent.DRAG_ENTER,this.handleDragEntered);
               this.moduleItem.addEventListener(DragEvent.DRAG_EXIT,this.handleDragExit);
               this.moduleItem.addEventListener(MouseEvent.ROLL_OVER,this._rollCallback);
               this.moduleItem.addEventListener(MouseEvent.ROLL_OUT,this._rollCallback);
               callLater(this.moduleItem.initIcon);
               callLater(this.secondModuleItem.initIcon);
               this.secondModuleItem.addEventListener(MouseEvent.CLICK,this._clickCallback);
               this.secondModuleItem.addEventListener(DragEvent.DRAG_DROP,this._droppingCallback);
               this.secondModuleItem.addEventListener(DragEvent.DRAG_ENTER,this.handleDragEntered);
               this.secondModuleItem.addEventListener(DragEvent.DRAG_EXIT,this.handleDragExit);
               this.secondModuleItem.addEventListener(MouseEvent.ROLL_OVER,this._rollCallback);
               this.secondModuleItem.addEventListener(MouseEvent.ROLL_OUT,this._rollCallback);
               callLater(this.modules.addElement,[this.secondModuleItem]);
               this.modules.toolTip = BPLocale.getItem("tooltip_accepts_only_hub_modules");
         }
      }
      
      private function handleDragEntered(param1:DragEvent) : void
      {
         var _loc2_:ModuleItem = param1.currentTarget as ModuleItem;
         if(_loc2_)
         {
            _loc2_.hovered = true;
         }
         DragManager.acceptDragDrop(param1.currentTarget as IUIComponent);
      }
      
      private function handleDragExit(param1:DragEvent) : void
      {
         var _loc2_:ModuleItem = param1.currentTarget as ModuleItem;
         if(_loc2_)
         {
            _loc2_.hovered = false;
         }
      }
      
      public function setSecondModuleStuff(param1:int, param2:int) : void
      {
         this.secondModuleItemType = param1;
         this.secondModuleItemItemId = param2;
      }
      
      protected function handleCreationComplete() : void
      {
         this.secondModuleItem.slotId = this._slotId2;
         this.secondModuleItem.moduleType = this.secondModuleItemType;
         this.secondModuleItem.itemId = this.secondModuleItemItemId;
         this.updateLayout();
      }
      
      public function get slotId2() : int
      {
         return this._slotId2;
      }
      
      public function set slotId2(param1:int) : void
      {
         this._slotId2 = param1;
      }
      
      public function get slotId() : int
      {
         return this._slotId;
      }
      
      public function set slotId(param1:int) : void
      {
         this._slotId = param1;
      }
      
      public function get droppingCallback() : Function
      {
         return this._droppingCallback;
      }
      
      public function set droppingCallback(param1:Function) : void
      {
         this._droppingCallback = param1;
      }
      
      public function get clickCallback() : Function
      {
         return this._clickCallback;
      }
      
      public function set clickCallback(param1:Function) : void
      {
         this._clickCallback = param1;
      }
      
      public function set rollCallback(param1:Function) : void
      {
         this._rollCallback = param1;
      }
      
      public function clean() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get singleHolsterBackground() : BorderContainer
      {
         return this._581526855singleHolsterBackground;
      }
      
      public function set singleHolsterBackground(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._581526855singleHolsterBackground;
         if(_loc2_ !== param1)
         {
            this._581526855singleHolsterBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"singleHolsterBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get doubleHolsterBackground() : BorderContainer
      {
         return this._2107016784doubleHolsterBackground;
      }
      
      public function set doubleHolsterBackground(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._2107016784doubleHolsterBackground;
         if(_loc2_ !== param1)
         {
            this._2107016784doubleHolsterBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"doubleHolsterBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get modules() : HGroup
      {
         return this._1227433863modules;
      }
      
      public function set modules(param1:HGroup) : void
      {
         var _loc2_:Object = this._1227433863modules;
         if(_loc2_ !== param1)
         {
            this._1227433863modules = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modules",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get moduleItem() : ModuleItem
      {
         return this._870482017moduleItem;
      }
      
      public function set moduleItem(param1:ModuleItem) : void
      {
         var _loc2_:Object = this._870482017moduleItem;
         if(_loc2_ !== param1)
         {
            this._870482017moduleItem = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moduleItem",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundFlash() : Rect
      {
         return this._1289795426backgroundFlash;
      }
      
      public function set backgroundFlash(param1:Rect) : void
      {
         var _loc2_:Object = this._1289795426backgroundFlash;
         if(_loc2_ !== param1)
         {
            this._1289795426backgroundFlash = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundFlash",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get progressBar() : ProgressBar
      {
         return this._1131509414progressBar;
      }
      
      public function set progressBar(param1:ProgressBar) : void
      {
         var _loc2_:Object = this._1131509414progressBar;
         if(_loc2_ !== param1)
         {
            this._1131509414progressBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progressBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get healthBar() : ProgressBar
      {
         return this._29266967healthBar;
      }
      
      public function set healthBar(param1:ProgressBar) : void
      {
         var _loc2_:Object = this._29266967healthBar;
         if(_loc2_ !== param1)
         {
            this._29266967healthBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"healthBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sheildBar() : ProgressBar
      {
         return this._1717220706sheildBar;
      }
      
      public function set sheildBar(param1:ProgressBar) : void
      {
         var _loc2_:Object = this._1717220706sheildBar;
         if(_loc2_ !== param1)
         {
            this._1717220706sheildBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sheildBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get installedModuleBars() : VGroup
      {
         return this._1370780058installedModuleBars;
      }
      
      public function set installedModuleBars(param1:VGroup) : void
      {
         var _loc2_:Object = this._1370780058installedModuleBars;
         if(_loc2_ !== param1)
         {
            this._1370780058installedModuleBars = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installedModuleBars",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _slotId() : int
      {
         return this._1809017048_slotId;
      }
      
      protected function set _slotId(param1:int) : void
      {
         var _loc2_:Object = this._1809017048_slotId;
         if(_loc2_ !== param1)
         {
            this._1809017048_slotId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_slotId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _slotId2() : int
      {
         return this._244953690_slotId2;
      }
      
      private function set _slotId2(param1:int) : void
      {
         var _loc2_:Object = this._244953690_slotId2;
         if(_loc2_ !== param1)
         {
            this._244953690_slotId2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_slotId2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _droppingCallback() : Function
      {
         return this._1617565349_droppingCallback;
      }
      
      private function set _droppingCallback(param1:Function) : void
      {
         var _loc2_:Object = this._1617565349_droppingCallback;
         if(_loc2_ !== param1)
         {
            this._1617565349_droppingCallback = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_droppingCallback",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _clickCallback() : Function
      {
         return this._917498898_clickCallback;
      }
      
      private function set _clickCallback(param1:Function) : void
      {
         var _loc2_:Object = this._917498898_clickCallback;
         if(_loc2_ !== param1)
         {
            this._917498898_clickCallback = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_clickCallback",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _rollCallback() : Function
      {
         return this._341156289_rollCallback;
      }
      
      private function set _rollCallback(param1:Function) : void
      {
         var _loc2_:Object = this._341156289_rollCallback;
         if(_loc2_ !== param1)
         {
            this._341156289_rollCallback = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_rollCallback",_loc2_,param1));
            }
         }
      }
   }
}

