package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingArenaPerformanceInfoCommand implements IModule
   {
      
      private static var _instance:TrainingArenaPerformanceInfoCommand;
      
      public var performance:Vector.<TrainingArenaPerformanceEntryCommand>;
      
      public function TrainingArenaPerformanceInfoCommand(param1:Vector.<TrainingArenaPerformanceEntryCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.performance = new Vector.<TrainingArenaPerformanceEntryCommand>();
         }
         else
         {
            this.performance = param1;
         }
      }
      
      public static function get instance() : TrainingArenaPerformanceInfoCommand
      {
         return _instance || (_instance = new TrainingArenaPerformanceInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31918;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TrainingArenaPerformanceEntryCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.performance.length > 0)
         {
            this.performance.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TrainingArenaPerformanceEntryCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.performance.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TrainingArenaPerformanceEntryCommand = null;
         param1.writeShort(31918);
         param1.writeByte(this.performance.length);
         for each(_loc2_ in this.performance)
         {
            _loc2_.write(param1);
         }
      }
   }
}

