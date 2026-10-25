package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ExpeditionClearanceTimeCommand implements IModule
   {
      
      private static var _instance:ExpeditionClearanceTimeCommand;
      
      public var seconds:int = 0;
      
      public var faction:FactionModule;
      
      public var userName:String = "";
      
      public var shipLootId:String = "";
      
      public var userId:int = 0;
      
      public function ExpeditionClearanceTimeCommand(param1:int = 0, param2:String = "", param3:FactionModule = null, param4:int = 0, param5:String = "")
      {
         super();
         this.seconds = param4;
         if(param3 == null)
         {
            this.faction = new FactionModule();
         }
         else
         {
            this.faction = param3;
         }
         this.userName = param2;
         this.shipLootId = param5;
         this.userId = param1;
      }
      
      public static function get instance() : ExpeditionClearanceTimeCommand
      {
         return _instance || (_instance = new ExpeditionClearanceTimeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6918;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.seconds = param1.readInt();
         this.seconds = this.seconds << 13 % 32 | this.seconds >>> 32 - 13 % 32;
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
         this.userName = param1.readUTF();
         this.shipLootId = param1.readUTF();
         this.userId = param1.readInt();
         this.userId = this.userId << 12 % 32 | this.userId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6918);
         param1.writeInt(this.seconds >>> 13 % 32 | this.seconds << 32 - 13 % 32);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.userName);
         param1.writeUTF(this.shipLootId);
         param1.writeInt(this.userId >>> 12 % 32 | this.userId << 32 - 12 % 32);
      }
   }
}

