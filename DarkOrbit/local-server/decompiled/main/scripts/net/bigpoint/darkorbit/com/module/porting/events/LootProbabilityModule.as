package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LootProbabilityModule implements IModule
   {
      
      private static var _instance:LootProbabilityModule;
      
      public var maxLootAmount:int = 0;
      
      public var minLootAmount:int = 0;
      
      public var probabilityPercentage:Number = 0;
      
      public var lootId:String = "";
      
      public function LootProbabilityModule(param1:Number = 0, param2:String = "", param3:int = 0, param4:int = 0)
      {
         super();
         this.maxLootAmount = param4;
         this.minLootAmount = param3;
         this.probabilityPercentage = param1;
         this.lootId = param2;
      }
      
      public static function get instance() : LootProbabilityModule
      {
         return _instance || (_instance = new LootProbabilityModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 684;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.maxLootAmount = param1.readInt();
         this.maxLootAmount = this.maxLootAmount >>> 10 % 32 | this.maxLootAmount << 32 - 10 % 32;
         this.minLootAmount = param1.readInt();
         this.minLootAmount = this.minLootAmount >>> 12 % 32 | this.minLootAmount << 32 - 12 % 32;
         this.probabilityPercentage = param1.readDouble();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(684);
         param1.writeInt(this.maxLootAmount << 10 % 32 | this.maxLootAmount >>> 32 - 10 % 32);
         param1.writeInt(this.minLootAmount << 12 % 32 | this.minLootAmount >>> 32 - 12 % 32);
         param1.writeDouble(this.probabilityPercentage);
         param1.writeUTF(this.lootId);
      }
   }
}

