package net.bigpoint.darkorbit.mvc.hintSystem.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class HintSystemWindowsProxy extends Proxy
   {
      
      public static const NAME:String = "HintSystemProxy";
      
      public static const SORTING_BEHAVIOUR_DESC:uint = 4;
      
      public static const SORTING_BEHAVIOUR_ASC:uint = 8;
      
      protected var _sortingBehaviour:uint = 4;
      
      private var _windows:Dictionary;
      
      public function HintSystemWindowsProxy()
      {
         super(HintSystemWindowsProxy.NAME);
         this._windows = new Dictionary();
      }
      
      public function set windows(param1:Dictionary) : void
      {
         this._windows = param1;
         sendNotification(HintSystemNotifications.WINDOWLIST_CHANGED,this.getWindowList());
      }
      
      public function addWindow(param1:uint, param2:IHintSystemContentDescription) : void
      {
         var _loc3_:Boolean = false;
         if(this._windows)
         {
            _loc3_ = this._addWindow(param1,param2);
            if(_loc3_)
            {
               sendNotification(HintSystemNotifications.WINDOWLIST_CHANGED,this.getWindowList());
            }
         }
      }
      
      protected function _addWindow(param1:uint, param2:IHintSystemContentDescription) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this._windows[param1] == null)
         {
            this._windows[param1] = param2;
            return true;
         }
         return _loc3_;
      }
      
      public function getWindowByContentID(param1:uint) : IHintSystemContentDescription
      {
         return this._windows[param1];
      }
      
      public function getWindowList() : Vector.<IHintSystemContentDescription>
      {
         var _loc2_:IHintSystemContentDescription = null;
         var _loc1_:Vector.<IHintSystemContentDescription> = new Vector.<IHintSystemContentDescription>();
         for each(_loc2_ in this._windows)
         {
            if(_loc2_)
            {
               _loc1_.push(_loc2_);
            }
         }
         switch(this._sortingBehaviour)
         {
            case SORTING_BEHAVIOUR_DESC:
               _loc1_.sort(this.descandingSortBehaviour);
               break;
            case SORTING_BEHAVIOUR_ASC:
               _loc1_.sort(this.ascandingSortBehaviour);
         }
         return _loc1_;
      }
      
      public function changeSortBehaviour(param1:uint) : void
      {
         if(param1 != this._sortingBehaviour)
         {
            this._sortingBehaviour = param1;
            sendNotification(HintSystemNotifications.WINDOWLIST_CHANGED,this.getWindowList());
         }
      }
      
      private function descandingSortBehaviour(param1:IHintSystemContentDescription, param2:IHintSystemContentDescription) : int
      {
         return param2.sortOrder - param1.sortOrder;
      }
      
      private function ascandingSortBehaviour(param1:IHintSystemContentDescription, param2:IHintSystemContentDescription) : int
      {
         return param1.sortOrder - param2.sortOrder;
      }
   }
}

