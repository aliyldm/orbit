package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   
   public class TooltipControl implements IFrameObserver
   {
      
      private static var _instance:TooltipControl;
      
      private var toolTipsList:Array;
      
      private var stickyToolTipsList:Array;
      
      private var bounds:Rectangle;
      
      private var _tpf:Number = 0;
      
      public function TooltipControl(param1:Function)
      {
         var _loc2_:String = null;
         super();
         if(param1 !== hidden)
         {
            _loc2_ = "TooltipControl is a Singleton and can only be accessed through TooltipControl.getInstance()";
            throw new Error(_loc2_);
         }
         this.init();
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : TooltipControl
      {
         if(_instance == null)
         {
            _instance = new TooltipControl(hidden);
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.toolTipsList = [];
         this.stickyToolTipsList = [];
      }
      
      public function addToolTip(param1:InteractiveObject, param2:String, param3:Boolean = false) : ToolTipHook
      {
         if(!param2 || param2.length < 1)
         {
            return null;
         }
         if(this.getToolTipForObject(param1))
         {
            this.removeToolTip(param1);
         }
         var _loc4_:ToolTipHook = new ToolTipHook(param1,param2,param3);
         _loc4_.setBounds(this.bounds);
         _loc4_.addEventListeners();
         this.toolTipsList.push(_loc4_);
         return _loc4_;
      }
      
      public function getToolTipForObject(param1:InteractiveObject) : ToolTipHook
      {
         var _loc3_:ToolTipHook = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.toolTipsList.length)
         {
            _loc3_ = this.toolTipsList[_loc2_];
            if(param1 == _loc3_.getTargetObject())
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addStickyToolTip(param1:DisplayObject, param2:String, param3:int, param4:int, param5:int = 220, param6:Boolean = false) : StickyToolTipHook
      {
         if(param2 == null)
         {
            return null;
         }
         if(param2.length < 1)
         {
            return null;
         }
         var _loc7_:StickyToolTipHook = new StickyToolTipHook(param1,param2,param3,param4,param5,param6);
         _loc7_.setBounds(this.bounds);
         this.stickyToolTipsList.push(_loc7_);
         return _loc7_;
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         var _loc2_:ToolTipHook = null;
         var _loc3_:StickyToolTipHook = null;
         this.bounds = param1;
         for each(_loc2_ in this.toolTipsList)
         {
            _loc2_.setBounds(param1);
         }
         for each(_loc3_ in this.stickyToolTipsList)
         {
            _loc3_.setBounds(param1);
         }
      }
      
      public function removeToolTip(param1:InteractiveObject) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.toolTipsList.length)
         {
            if(ToolTipHook(this.toolTipsList[_loc2_]).getTargetObject() == param1)
            {
               ToolTipHook(this.toolTipsList[_loc2_]).suicide();
               this.toolTipsList.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function removeStickyToolTip(param1:InteractiveObject) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.stickyToolTipsList.length)
         {
            if(StickyToolTipHook(this.stickyToolTipsList[_loc2_]).getTargetObject() == param1)
            {
               StickyToolTipHook(this.stickyToolTipsList[_loc2_]).suicide();
               this.stickyToolTipsList.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function hideAllToolTips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.toolTipsList.length)
         {
            if(this.toolTipsList[_loc1_] != undefined && this.toolTipsList[_loc1_] != null)
            {
               ToolTipHook(this.toolTipsList[_loc1_]).hideTooltip();
            }
            _loc1_++;
         }
      }
      
      public function showAllStickyToolTips() : void
      {
         ScreenManager.addObserver(this);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:StickyToolTipHook = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:SimpleWindow = null;
         this._tpf += param1;
         if(this._tpf > 999)
         {
            _loc2_ = 0;
            while(_loc2_ < this.stickyToolTipsList.length)
            {
               _loc3_ = StickyToolTipHook(this.stickyToolTipsList[_loc2_]);
               _loc4_ = _loc3_.getTargetObject();
               if(_loc4_ is SimpleWindow)
               {
                  _loc5_ = SimpleWindow(_loc4_);
                  if(_loc5_.maximized && _loc5_.hasHelpText())
                  {
                     StickyToolTipHook(this.stickyToolTipsList[_loc2_]).showTooltip();
                  }
               }
               else
               {
                  StickyToolTipHook(this.stickyToolTipsList[_loc2_]).showTooltip();
               }
               _loc2_++;
            }
            this.removeTimer();
         }
      }
      
      private function removeTimer() : void
      {
         ScreenManager.removeObserver(this);
         this._tpf = 0;
      }
      
      public function hideAllStickyToolTips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.stickyToolTipsList.length)
         {
            StickyToolTipHook(this.stickyToolTipsList[_loc1_]).hideTooltip();
            _loc1_++;
         }
         this.removeTimer();
      }
   }
}

