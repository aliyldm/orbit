package net.bigpoint.darkorbit.mvc.ccCommands.model
{
   import flash.utils.ByteArray;
   import net.bigpoint.darkorbit.com.module.CCommandRequest;
   import net.bigpoint.darkorbit.utils.ByteArrayUtils;
   import org.as3commons.lang.StringUtils;
   
   public class CCHistoryEntry
   {
      
      private static const TMP_BA1:ByteArray = new ByteArray();
      
      private static const TMP_BA2:ByteArray = new ByteArray();
      
      private var _request:CCommandRequest;
      
      private var _key:int = -1;
      
      public function CCHistoryEntry()
      {
         super();
      }
      
      public static function read(param1:ByteArray) : CCHistoryEntry
      {
         var _loc2_:CCHistoryEntry = new CCHistoryEntry();
         _loc2_.key = param1.readInt();
         param1.readShort();
         var _loc3_:CCommandRequest = new CCommandRequest();
         _loc3_.read(param1);
         _loc2_._request = _loc3_;
         return _loc2_;
      }
      
      public static function sort(param1:CCHistoryEntry, param2:CCHistoryEntry) : int
      {
         if(param1.key == -1 && param2.key == -1 || param1.key != -1 && param2.key != -1)
         {
            return StringUtils.compareTo(param1.request.name,param2.request.name);
         }
         return param2.key - param1.key;
      }
      
      public function get request() : CCommandRequest
      {
         return this._request;
      }
      
      public function set request(param1:CCommandRequest) : void
      {
         this._request = param1;
      }
      
      public function get key() : int
      {
         return this._key;
      }
      
      public function set key(param1:int) : void
      {
         this._key = param1;
      }
      
      public function write(param1:ByteArray) : void
      {
         param1.writeInt(this._key);
         this._request.write(param1);
      }
      
      public function equals(param1:CCHistoryEntry) : Boolean
      {
         return this.key == param1.key && this.hasEqualRequest(param1._request);
      }
      
      public function hasEqualRequest(param1:CCommandRequest) : Boolean
      {
         TMP_BA1.clear();
         TMP_BA2.clear();
         param1.write(TMP_BA1);
         this._request.write(TMP_BA2);
         return ByteArrayUtils.equal(TMP_BA1,TMP_BA2);
      }
   }
}

