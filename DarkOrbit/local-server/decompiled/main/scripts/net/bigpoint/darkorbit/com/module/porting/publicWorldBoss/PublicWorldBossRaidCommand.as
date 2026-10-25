package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class PublicWorldBossRaidCommand implements IModule
   {
      
      private static var _instance:PublicWorldBossRaidCommand;
      
      public var raidlist:Vector.<PublicWorldBossRaidIntensity>;
      
      public function PublicWorldBossRaidCommand(param1:Vector.<PublicWorldBossRaidIntensity> = null)
      {
         super();
         if(param1 == null)
         {
            this.raidlist = new Vector.<PublicWorldBossRaidIntensity>();
         }
         else
         {
            this.raidlist = param1;
         }
      }
      
      public static function get instance() : PublicWorldBossRaidCommand
      {
         return _instance || (_instance = new PublicWorldBossRaidCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13647;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PublicWorldBossRaidIntensity = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.raidlist.length > 0)
         {
            this.raidlist.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PublicWorldBossRaidIntensity(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.raidlist.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PublicWorldBossRaidIntensity = null;
         param1.writeShort(13647);
         param1.writeByte(this.raidlist.length);
         for each(_loc2_ in this.raidlist)
         {
            _loc2_.write(param1);
         }
      }
   }
}

