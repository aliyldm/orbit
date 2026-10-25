package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyInfoCommand;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyOwnerUpdateCommand;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyScheduleUpdateCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TitleFrenzyUIOverviewData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const activeStatusUpdated:ISignal = new Signal();
      
      public const ownersUpdated:ISignal = new Signal();
      
      public const scheduleTimer:BindableCountDown = new BindableCountDown();
      
      public const eventEndTimer:BindableCountDown = new BindableCountDown();
      
      private var _titleKey:String;
      
      private var _scheduleInactive:Boolean;
      
      private var _npcList:Vector.<int> = new Vector.<int>(0);
      
      private var _owners:Vector.<TitleFrenzyVO> = new Vector.<TitleFrenzyVO>(0);
      
      public function TitleFrenzyUIOverviewData()
      {
         super();
      }
      
      public function get titleKey() : String
      {
         return this._titleKey;
      }
      
      public function get scheduleInactive() : Boolean
      {
         return this._scheduleInactive;
      }
      
      public function get npcList() : Vector.<int>
      {
         return this._npcList;
      }
      
      public function get owners() : Vector.<TitleFrenzyVO>
      {
         return this._owners;
      }
      
      public function updateInfo(param1:TitleFrenzyInfoCommand) : void
      {
         this.eventEndTimer.value = param1.timeToEventEnd;
         this._npcList = param1.npcIds;
         this._titleKey = param1.titleKey;
         this.updateScheduleInfo(param1.schedule);
         this.changed.dispatch();
      }
      
      public function updateScheduleInfo(param1:TitleFrenzyScheduleUpdateCommand) : void
      {
         var _loc2_:Boolean = this._scheduleInactive;
         this._scheduleInactive = param1.timeToNextWindow > 0;
         if(this._scheduleInactive)
         {
            this.scheduleTimer.value = param1.timeToNextWindow;
         }
         else
         {
            this.scheduleTimer.value = param1.timeToWindowEnd;
         }
         if(_loc2_ != this._scheduleInactive)
         {
            this.activeStatusUpdated.dispatch();
         }
      }
      
      public function updateOwnerInfo(param1:TitleFrenzyOwnerUpdateCommand) : void
      {
         var _loc2_:TitleFrenzyVO = null;
         for each(_loc2_ in this._owners)
         {
            if(_loc2_.titleId == param1.titleId)
            {
               _loc2_.username = param1.username;
               _loc2_.mapId = param1.mapId;
               this.ownersUpdated.dispatch();
               return;
            }
         }
         this._owners.push(new TitleFrenzyVO(param1));
         this._owners.sort(TitleFrenzyVO.sort);
         this.ownersUpdated.dispatch();
      }
   }
}

