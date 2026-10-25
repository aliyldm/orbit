package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HintWindowListInitCommand implements IModule
   {
      
      private static var _instance:HintWindowListInitCommand;
      
      public var windows:Vector.<HintWindowModule>;
      
      public function HintWindowListInitCommand(param1:Vector.<HintWindowModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.windows = new Vector.<HintWindowModule>();
         }
         else
         {
            this.windows = param1;
         }
      }
      
      public static function get instance() : HintWindowListInitCommand
      {
         return _instance || (_instance = new HintWindowListInitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2840;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HintWindowModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.windows.length > 0)
         {
            this.windows.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HintWindowModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.windows.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HintWindowModule = null;
         param1.writeShort(-2840);
         param1.writeByte(this.windows.length);
         for each(_loc2_ in this.windows)
         {
            _loc2_.write(param1);
         }
      }
   }
}

