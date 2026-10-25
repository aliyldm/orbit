package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrinityTrialsDropLevelOptionalRequest implements IModule
   {
      
      private static var _instance:TrinityTrialsDropLevelOptionalRequest;
      
      public var costLootAmount:int = 0;
      
      public var costLootId:String = "";
      
      public function TrinityTrialsDropLevelOptionalRequest(param1:String = "", param2:int = 0)
      {
         super();
         this.costLootAmount = param2;
         this.costLootId = param1;
      }
      
      public static function get instance() : TrinityTrialsDropLevelOptionalRequest
      {
         return _instance || (_instance = new TrinityTrialsDropLevelOptionalRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4087;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.costLootAmount = param1.readInt();
         this.costLootAmount = this.costLootAmount << 15 % 32 | this.costLootAmount >>> 32 - 15 % 32;
         this.costLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4087);
         param1.writeInt(this.costLootAmount >>> 15 % 32 | this.costLootAmount << 32 - 15 % 32);
         param1.writeUTF(this.costLootId);
      }
   }
}

