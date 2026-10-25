package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.EventProgressNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.utils.EventProgressXMLParser;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo.EventProgressVO;
   
   public class EventProgressProxy extends SimpleWindowProxy
   {
      
      private var _eventId:String;
      
      private var _eventProgress:Number = 0;
      
      private var _eventProgressVO:EventProgressVO;
      
      private var _eventXML:XML;
      
      public function EventProgressProxy(param1:String, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function updateProgress(param1:Number, param2:Boolean = false) : void
      {
         if(this._eventProgressVO)
         {
            if(param1 <= this._eventProgressVO.maxUnlockRequirement)
            {
               if(param1 != this._eventProgress || param2)
               {
                  this._eventProgress = param1;
                  this.notifyEventProgressChanged();
               }
            }
         }
         else
         {
            this._eventProgress = param1;
         }
      }
      
      public function load(param1:String) : void
      {
         if(this._eventId != param1)
         {
            this._eventId = param1;
            sendNotification(AssetNotifications.LOAD_ASSET,[param1,this.handleLoaded,this.handleLoadError]);
         }
      }
      
      private function handleLoaded(param1:XMLFinisher) : void
      {
         this._eventXML = param1.getXML();
         if(this._eventXML)
         {
            this._eventProgressVO = EventProgressXMLParser.parse(this._eventXML) as EventProgressVO;
            this._eventXML = null;
            this.notifyEventProgressDataChanged();
            this.updateProgress(this._eventProgress,true);
         }
      }
      
      private function handleLoadError(param1:FileCollectionFinisher) : void
      {
      }
      
      private function notifyEventProgressDataChanged() : void
      {
         sendNotification(EventProgressNotifications.EVENT_PROGRESS_DATA_CHANGED,this.eventProgressVO);
      }
      
      private function notifyEventProgressChanged() : void
      {
         sendNotification(EventProgressNotifications.UPDATE_PROGRESS,this._eventProgress);
      }
      
      public function get eventProgressVO() : EventProgressVO
      {
         return this._eventProgressVO;
      }
   }
}

