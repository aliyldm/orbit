package net.bigpoint.darkorbit.mvc.epicMessages.model
{
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.EpicFightMessageCommand;
   import net.bigpoint.darkorbit.com.module.EpicFightMessageTypeModule;
   import net.bigpoint.darkorbit.com.module.EpicNumberedFightMessageTypeModule;
   import net.bigpoint.darkorbit.mvc.epicMessages.EpicFightNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.EpicMessageVo;
   
   public class EpicFightMessageProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "EpicFightMessageProxy";
      
      private var FACTORY_CALLS:Dictionary = new Dictionary();
      
      private var _timerPointer:int = -1;
      
      public function EpicFightMessageProxy()
      {
         super(NAME,new Vector.<EpicMessageVo>());
         this.FACTORY_CALLS[EpicNumberedFightMessageTypeModule.instance.getLibcomModuleId()] = this.handleEpicNumberedFightMessageTypeModule;
         this.FACTORY_CALLS[EpicFightMessageTypeModule.instance.getLibcomModuleId()] = this.handleEpicFightMessageTypeModule;
      }
      
      private function get model() : Vector.<EpicMessageVo>
      {
         return data as Vector.<EpicMessageVo>;
      }
      
      public function addMessage(param1:EpicFightMessageCommand) : void
      {
         this.model.push(this.createVO(param1));
         this.update();
      }
      
      private function update() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Vector.<EpicMessageVo> = this.model;
         _loc1_.sort(EpicMessageVo.sortOnPrio);
         var _loc2_:int = int(_loc1_.length);
         if(_loc1_.length > 0)
         {
            _loc3_ = -1;
            _loc4_ = _loc1_[0].prio;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               if(_loc1_[_loc5_].prio < _loc4_)
               {
                  _loc3_ = _loc5_;
                  break;
               }
               _loc5_++;
            }
            if(_loc4_ > 0)
            {
               if(_loc3_ != -1)
               {
                  _loc1_.splice(_loc3_,_loc2_ - _loc3_);
               }
            }
            else
            {
               _loc1_.splice(0,_loc2_ - 1);
            }
            if(this._timerPointer == -1)
            {
               this.showNextMessage();
            }
         }
      }
      
      private function showNextMessage() : void
      {
         var _loc1_:EpicMessageVo = null;
         if(this.model.length > 0)
         {
            _loc1_ = this.model.shift();
            this._timerPointer = setTimeout(this.showNextMessage,_loc1_.duration);
            sendNotification(EpicFightNotifications.SHOW_MESSAGE,_loc1_);
         }
         else
         {
            this._timerPointer = -1;
         }
      }
      
      private function createVO(param1:EpicFightMessageCommand) : EpicMessageVo
      {
         return this.FACTORY_CALLS[param1.type.getLibcomModuleId()](param1);
      }
      
      private function handleEpicFightMessageTypeModule(param1:EpicFightMessageCommand) : EpicMessageVo
      {
         var _loc2_:EpicFightMessageTypeModule = param1.type as EpicFightMessageTypeModule;
         var _loc3_:int = -1;
         if(_loc2_.type == EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_FIGHT)
         {
            _loc3_ = InGameCatalog.SOUND_ID_TDM_INTRO;
         }
         return new EpicMessageVo(InGameCatalog.instance.epicMessages[_loc2_.type],param1.duration,EpicMessageVo.NORMAL_PRIO,_loc3_);
      }
      
      private function handleEpicNumberedFightMessageTypeModule(param1:EpicFightMessageCommand) : EpicMessageVo
      {
         var _loc2_:EpicNumberedFightMessageTypeModule = param1.type as EpicNumberedFightMessageTypeModule;
         var _loc3_:int = _loc2_.type == EpicNumberedFightMessageTypeModule.EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_COUNTDOWN ? EpicMessageVo.LOW_PRIO : EpicMessageVo.NORMAL_PRIO;
         var _loc4_:int = -1;
         if(_loc2_.type == EpicNumberedFightMessageTypeModule.EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_COUNTDOWN && _loc2_.number <= 5 && _loc2_.number >= 1)
         {
            _loc4_ = InGameCatalog.SOUND_ID_STICKYBOMB_BEEP;
         }
         var _loc5_:String = String(InGameCatalog.instance.epicNumberedMessages[_loc2_.type]).replace(/%NUMBER%/,_loc2_.number);
         return new EpicMessageVo(_loc5_,param1.duration,_loc3_,_loc4_);
      }
   }
}

