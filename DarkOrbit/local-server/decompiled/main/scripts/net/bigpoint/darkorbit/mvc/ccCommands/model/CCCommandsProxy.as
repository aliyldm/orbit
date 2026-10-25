package net.bigpoint.darkorbit.mvc.ccCommands.model
{
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import net.bigpoint.darkorbit.com.module.CCommandRequest;
   import net.bigpoint.darkorbit.mvc.ccCommands.CCCommandNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   
   public class CCCommandsProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "CCCommandsProxy";
      
      private var _ready:Boolean;
      
      private var _lso:SharedObject = SharedObject.getLocal("darkorbit_cc_history","/");
      
      private var _history:Vector.<CCHistoryEntry> = new Vector.<CCHistoryEntry>(0);
      
      private const MAX_HISTORY:int = 20;
      
      public function CCCommandsProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this._ready = true;
         super.setData(param1);
         this.readHistory();
         sendNotification(CCCommandNotifications.UPDATE,param1);
         sendNotification(CCCommandNotifications.UPDATE_HISTORY,this._history);
      }
      
      private function readHistory() : void
      {
         var ba:ByteArray = this._lso.data["history"];
         if(ba)
         {
            try
            {
               while(ba.bytesAvailable)
               {
                  this._history.push(CCHistoryEntry.read(ba));
               }
            }
            catch(e:Error)
            {
               facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage("CCCommandsProxy.readHistory \n" + e.getStackTrace()));
            }
            finally
            {
               this._lso.clear();
               this._lso.flush();
               this.writeToDisc();
            }
         }
         this._history.sort(CCHistoryEntry.sort);
      }
      
      public function writeToHistory(param1:CCommandRequest) : void
      {
         if(!this.hasHistoryEntry(param1))
         {
            this.getOrAddHistoryEntryWithRequest(param1);
            this.writeToDisc();
            sendNotification(CCCommandNotifications.UPDATE_HISTORY,this._history);
         }
      }
      
      private function hasHistoryEntry(param1:CCommandRequest) : Boolean
      {
         var _loc4_:CCHistoryEntry = null;
         var _loc2_:int = int(this._history.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._history[_loc3_];
            if(_loc4_.hasEqualRequest(param1))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function writeToDisc() : void
      {
         var ba:ByteArray = null;
         var len:int = 0;
         var i:int = 0;
         var entry:CCHistoryEntry = null;
         try
         {
            this._lso.clear();
            ba = new ByteArray();
            len = Math.min(this._history.length,this.MAX_HISTORY);
            i = 0;
            while(i < len)
            {
               entry = this._history[i];
               entry.write(ba);
               i++;
            }
            this._lso.data["history"] = ba;
            this._lso.flush();
         }
         catch(e:Error)
         {
            _lso.clear();
            _lso.flush();
            facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage("CCCommandsProxy.writeToDisc \n" + e.getStackTrace()));
         }
      }
      
      public function assignHotKeyToHistory(param1:int, param2:CCommandRequest) : void
      {
         this.getOrAddHistoryEntryWithRequest(param2).key = param1;
         this._history.sort(CCHistoryEntry.sort);
         this.writeToDisc();
         sendNotification(CCCommandNotifications.UPDATE_HISTORY,this._history);
      }
      
      private function getOrAddHistoryEntryWithRequest(param1:CCommandRequest) : CCHistoryEntry
      {
         var _loc4_:CCHistoryEntry = null;
         var _loc2_:int = int(this._history.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._history[_loc3_];
            if(_loc4_.hasEqualRequest(param1))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         _loc4_ = new CCHistoryEntry();
         _loc4_.request = param1;
         this._history.push(_loc4_);
         this._history.sort(CCHistoryEntry.sort);
         return _loc4_;
      }
      
      public function clearHistory() : void
      {
         this._history = new Vector.<CCHistoryEntry>(0);
         this.writeToDisc();
         sendNotification(CCCommandNotifications.UPDATE_HISTORY,this._history);
      }
   }
}

