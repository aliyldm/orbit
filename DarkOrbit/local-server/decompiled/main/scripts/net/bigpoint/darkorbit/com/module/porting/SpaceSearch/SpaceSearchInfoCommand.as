package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpaceSearchInfoCommand implements IModule
   {
      
      private static var _instance:SpaceSearchInfoCommand;
      
      public var planetIndex:int = 0;
      
      public var planetPct:int = 0;
      
      public var quantity:Number = 0;
      
      public var lootId:String = "";
      
      public var cost:Number = 0;
      
      public function SpaceSearchInfoCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:Number = 0, param5:Number = 0)
      {
         super();
         this.planetIndex = param1;
         this.planetPct = param2;
         this.quantity = param4;
         this.lootId = param3;
         this.cost = param5;
      }
      
      public static function get instance() : SpaceSearchInfoCommand
      {
         return _instance || (_instance = new SpaceSearchInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30954;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.planetIndex = param1.readInt();
         this.planetIndex = this.planetIndex >>> 3 % 32 | this.planetIndex << 32 - 3 % 32;
         this.planetPct = param1.readInt();
         this.planetPct = this.planetPct << 1 % 32 | this.planetPct >>> 32 - 1 % 32;
         this.quantity = param1.readDouble();
         this.lootId = param1.readUTF();
         this.cost = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30954);
         param1.writeInt(this.planetIndex << 3 % 32 | this.planetIndex >>> 32 - 3 % 32);
         param1.writeInt(this.planetPct >>> 1 % 32 | this.planetPct << 32 - 1 % 32);
         param1.writeDouble(this.quantity);
         param1.writeUTF(this.lootId);
         param1.writeDouble(this.cost);
      }
   }
}

