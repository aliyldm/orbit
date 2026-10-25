package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.*;
   
   public class SpaceSearchMissionListCommand implements IModule
   {
      
      private static var _instance:SpaceSearchMissionListCommand;
      
      public var missions:Vector.<EventQuestDefinitionModule>;
      
      public function SpaceSearchMissionListCommand(param1:Vector.<EventQuestDefinitionModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.missions = new Vector.<EventQuestDefinitionModule>();
         }
         else
         {
            this.missions = param1;
         }
      }
      
      public static function get instance() : SpaceSearchMissionListCommand
      {
         return _instance || (_instance = new SpaceSearchMissionListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4822;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventQuestDefinitionModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.missions.length > 0)
         {
            this.missions.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventQuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.missions.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventQuestDefinitionModule = null;
         param1.writeShort(-4822);
         param1.writeByte(this.missions.length);
         for each(_loc2_ in this.missions)
         {
            _loc2_.write(param1);
         }
      }
   }
}

