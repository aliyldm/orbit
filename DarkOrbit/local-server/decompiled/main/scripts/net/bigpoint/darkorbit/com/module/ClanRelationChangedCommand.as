package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanRelationChangedCommand implements IModule
   {
      
      private static var _instance:ClanRelationChangedCommand;
      
      public var clanId:int = 0;
      
      public var newRelation:ClanRelationModule;
      
      public var userId:int = 0;
      
      public function ClanRelationChangedCommand(param1:ClanRelationModule = null, param2:int = 0, param3:int = 0)
      {
         super();
         this.clanId = param3;
         if(param1 == null)
         {
            this.newRelation = new ClanRelationModule();
         }
         else
         {
            this.newRelation = param1;
         }
         this.userId = param2;
      }
      
      public static function get instance() : ClanRelationChangedCommand
      {
         return _instance || (_instance = new ClanRelationChangedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24945;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 7 % 32 | this.clanId << 32 - 7 % 32;
         this.newRelation = ClanRelationModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.newRelation)
         {
            this.newRelation.read(param1);
         }
         this.userId = param1.readInt();
         this.userId = this.userId << 11 % 32 | this.userId >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24945);
         param1.writeInt(this.clanId << 7 % 32 | this.clanId >>> 32 - 7 % 32);
         if(null != this.newRelation)
         {
            this.newRelation.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.userId >>> 11 % 32 | this.userId << 32 - 11 % 32);
      }
   }
}

