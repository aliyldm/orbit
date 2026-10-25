package net.bigpoint.darkorbit.mvc.commandCenter.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableSmartCountDown;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterNewsDefinition;
   import org.osflash.signals.Signal;
   
   public class CommandCenterNewsVO
   {
      
      public const refreshed:Signal = new Signal();
      
      public const timer:BindableSmartCountDown = new BindableSmartCountDown();
      
      public const isNew:BindableBoolean = new BindableBoolean(true);
      
      private var _data:CommandCenterNewsDefinition;
      
      private var _clickCount:int;
      
      public function CommandCenterNewsVO(param1:CommandCenterNewsDefinition)
      {
         super();
         this._data = param1;
      }
      
      public static function sort(param1:CommandCenterNewsVO, param2:CommandCenterNewsVO) : int
      {
         if(param1.isNew.value == param2.isNew.value)
         {
            return param1.data.prio - param2.data.prio;
         }
         if(param1.isNew.value)
         {
            return 1;
         }
         return -1;
      }
      
      public function get key() : String
      {
         return this._data.name;
      }
      
      public function get data() : CommandCenterNewsDefinition
      {
         return this._data;
      }
      
      public function get clickCount() : int
      {
         return this._clickCount;
      }
      
      public function set clickCount(param1:int) : void
      {
         this.isNew.value = param1 == 0;
         this._clickCount = param1;
      }
      
      public function updateTimeLeft(param1:Number) : void
      {
         if(this._data.showCountDown)
         {
            this.timer.value = param1;
         }
         else
         {
            this.timer.value = 0;
         }
         this.refreshed.dispatch();
      }
      
      public function toString() : String
      {
         return "CommandCenterNewsVO{_data=" + String(this._data) + ",_clickCount=" + String(this._clickCount) + "}";
      }
   }
}

