package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlPlayerCountModule implements IModule
   {
      
      private static var _instance:SectorControlPlayerCountModule;
      
      public var faction:FactionModule;
      
      public var playerCount:int = 0;
      
      public var maxPlayers:int = 0;
      
      public function SectorControlPlayerCountModule(param1:FactionModule = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.faction = new FactionModule();
         }
         else
         {
            this.faction = param1;
         }
         this.playerCount = param2;
         this.maxPlayers = param3;
      }
      
      public static function get instance() : SectorControlPlayerCountModule
      {
         return _instance || (_instance = new SectorControlPlayerCountModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7770;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
         this.playerCount = param1.readInt();
         this.playerCount = this.playerCount << 2 % 32 | this.playerCount >>> 32 - 2 % 32;
         this.maxPlayers = param1.readInt();
         this.maxPlayers = this.maxPlayers >>> 8 % 32 | this.maxPlayers << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7770);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.playerCount >>> 2 % 32 | this.playerCount << 32 - 2 % 32);
         param1.writeInt(this.maxPlayers << 8 % 32 | this.maxPlayers >>> 32 - 8 % 32);
      }
   }
}

