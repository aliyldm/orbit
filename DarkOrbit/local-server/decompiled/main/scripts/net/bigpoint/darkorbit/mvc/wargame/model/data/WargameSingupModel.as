package net.bigpoint.darkorbit.mvc.wargame.model.data
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.WarGameLobbyStatusModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WargameSingupModel
   {
      
      private var _rewards:Vector.<RewardContentModule>;
      
      private var _status:WarGameLobbyStatusModule;
      
      public const change:ISignal = new Signal();
      
      public function WargameSingupModel()
      {
         super();
      }
      
      public function set rewards(param1:Vector.<RewardContentModule>) : void
      {
         this._rewards = param1;
         this.change.dispatch();
      }
      
      public function get rewards() : Vector.<RewardContentModule>
      {
         return this._rewards;
      }
      
      public function set status(param1:WarGameLobbyStatusModule) : void
      {
         this._status = param1;
         this.change.dispatch();
      }
      
      public function get status() : WarGameLobbyStatusModule
      {
         return this._status;
      }
   }
}

