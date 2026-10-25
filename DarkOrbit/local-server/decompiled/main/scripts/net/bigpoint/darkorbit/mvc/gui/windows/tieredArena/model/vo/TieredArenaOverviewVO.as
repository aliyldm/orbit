package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.vo
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TieredArenaOverviewVO
   {
      
      public const changed:ISignal = new Signal();
      
      public const tooltipChanged:ISignal = new Signal();
      
      private var _arenaTimeLeft:BindableCountDown = new BindableCountDown();
      
      private var _eventTimeEnd:BindableCountDown = new BindableCountDown();
      
      private var _rep:uint;
      
      private var _reputationRequired:uint;
      
      private var _participationRewards:TieredArenaParticipationRewardsToolTipVO;
      
      private var _isArenaOpen:Boolean;
      
      public function TieredArenaOverviewVO()
      {
         super();
      }
      
      public function get rep() : uint
      {
         return this._rep;
      }
      
      public function set rep(param1:uint) : void
      {
         this._rep = param1;
         this.changed.dispatch();
      }
      
      public function get reputationRequired() : uint
      {
         return this._reputationRequired;
      }
      
      public function set reputationRequired(param1:uint) : void
      {
         this._reputationRequired = param1;
         this.changed.dispatch();
      }
      
      public function get participationRewards() : TieredArenaParticipationRewardsToolTipVO
      {
         return this._participationRewards;
      }
      
      public function set participationRewards(param1:TieredArenaParticipationRewardsToolTipVO) : void
      {
         this._participationRewards = param1;
         this.tooltipChanged.dispatch();
      }
      
      public function get arenaTimeLeft() : Number
      {
         return this._arenaTimeLeft.value;
      }
      
      public function set arenaTimeLeft(param1:Number) : void
      {
         this._arenaTimeLeft.value = param1;
         this.changed.dispatch();
      }
      
      public function set arenaTimeLeftChanged(param1:Function) : void
      {
         this._arenaTimeLeft.changed.removeAll();
         if(param1 == null)
         {
            return;
         }
         this._arenaTimeLeft.changed.add(param1);
      }
      
      public function get eventTimeEnd() : Number
      {
         return this._eventTimeEnd.value;
      }
      
      public function set eventTimeEnd(param1:Number) : void
      {
         this._eventTimeEnd.value = param1;
         this.changed.dispatch();
      }
      
      public function set arenaTimeEndChanged(param1:Function) : void
      {
         this._eventTimeEnd.changed.removeAll();
         if(param1 == null)
         {
            return;
         }
         this._eventTimeEnd.changed.add(param1);
      }
      
      public function get isArenaOpen() : Boolean
      {
         return this._isArenaOpen;
      }
      
      public function set isArenaOpen(param1:Boolean) : void
      {
         this._isArenaOpen = param1;
         this.changed.dispatch();
      }
   }
}

