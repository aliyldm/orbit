package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SkylabMainViewCommand implements IModule
   {
      
      private static var _instance:SkylabMainViewCommand;
      
      public var listModule:Vector.<SkylabMainViewModuleCommand>;
      
      public var oreList:Vector.<SkylabStorageOreCommand>;
      
      public function SkylabMainViewCommand(param1:Vector.<SkylabMainViewModuleCommand> = null, param2:Vector.<SkylabStorageOreCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.listModule = new Vector.<SkylabMainViewModuleCommand>();
         }
         else
         {
            this.listModule = param1;
         }
         if(param2 == null)
         {
            this.oreList = new Vector.<SkylabStorageOreCommand>();
         }
         else
         {
            this.oreList = param2;
         }
      }
      
      public static function get instance() : SkylabMainViewCommand
      {
         return _instance || (_instance = new SkylabMainViewCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27745;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SkylabMainViewModuleCommand = null;
         var _loc5_:SkylabStorageOreCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.listModule.length > 0)
         {
            this.listModule.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SkylabMainViewModuleCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.listModule.push(_loc4_);
            _loc2_++;
         }
         while(this.oreList.length > 0)
         {
            this.oreList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = SkylabStorageOreCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.oreList.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SkylabMainViewModuleCommand = null;
         var _loc3_:SkylabStorageOreCommand = null;
         param1.writeShort(27745);
         param1.writeByte(this.listModule.length);
         for each(_loc2_ in this.listModule)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.oreList.length);
         for each(_loc3_ in this.oreList)
         {
            _loc3_.write(param1);
         }
      }
   }
}

