package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankingsEventsInfoModule implements IModule
   {
      
      private static var _instance:RankingsEventsInfoModule;
      
      public var rank:int = 0;
      
      public var rankInfo:Vector.<String>;
      
      public function RankingsEventsInfoModule(param1:int = 0, param2:Vector.<String> = null)
      {
         super();
         this.rank = param1;
         if(param2 == null)
         {
            this.rankInfo = new Vector.<String>();
         }
         else
         {
            this.rankInfo = param2;
         }
      }
      
      public static function get instance() : RankingsEventsInfoModule
      {
         return _instance || (_instance = new RankingsEventsInfoModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8708;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rank = param1.readInt();
         this.rank = this.rank << 12 % 32 | this.rank >>> 32 - 12 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rankInfo.length > 0)
         {
            this.rankInfo.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.rankInfo.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(-8708);
         param1.writeInt(this.rank >>> 12 % 32 | this.rank << 32 - 12 % 32);
         param1.writeByte(this.rankInfo.length);
         for each(_loc2_ in this.rankInfo)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

