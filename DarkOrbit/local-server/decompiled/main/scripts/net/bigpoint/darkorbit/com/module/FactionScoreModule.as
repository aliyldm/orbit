package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FactionScoreModule implements IModule
   {
      
      private static var _instance:FactionScoreModule;
      
      public var faction:FactionModule;
      
      public var score:int = 0;
      
      public function FactionScoreModule(param1:FactionModule = null, param2:int = 0)
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
         this.score = param2;
      }
      
      public static function get instance() : FactionScoreModule
      {
         return _instance || (_instance = new FactionScoreModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9667;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
         this.score = param1.readInt();
         this.score = this.score << 13 % 32 | this.score >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9667);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.score >>> 13 % 32 | this.score << 32 - 13 % 32);
      }
   }
}

