package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestGiversAvailableCommand implements IModule
   {
      
      private static var _instance:QuestGiversAvailableCommand;
      
      public var questGivers:Vector.<QuestGiverModule>;
      
      public function QuestGiversAvailableCommand(param1:Vector.<QuestGiverModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.questGivers = new Vector.<QuestGiverModule>();
         }
         else
         {
            this.questGivers = param1;
         }
      }
      
      public static function get instance() : QuestGiversAvailableCommand
      {
         return _instance || (_instance = new QuestGiversAvailableCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2345;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestGiverModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.questGivers.length > 0)
         {
            this.questGivers.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestGiverModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.questGivers.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestGiverModule = null;
         param1.writeShort(2345);
         param1.writeByte(this.questGivers.length);
         for each(_loc2_ in this.questGivers)
         {
            _loc2_.write(param1);
         }
      }
   }
}

