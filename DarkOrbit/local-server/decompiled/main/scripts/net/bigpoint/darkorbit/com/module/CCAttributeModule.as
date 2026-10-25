package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCAttributeModule implements IModule
   {
      
      private static var _instance:CCAttributeModule;
      
      public var name:String = "";
      
      public var subAttributes:Vector.<CCAttributeModule>;
      
      public var singleAttributeSelection:Boolean = false;
      
      public var range:CCAbstractRangeModule;
      
      public var toolTip:String = "";
      
      public function CCAttributeModule(param1:Boolean = false, param2:Vector.<CCAttributeModule> = null, param3:String = "", param4:CCAbstractRangeModule = null, param5:String = "")
      {
         super();
         this.name = param3;
         if(param2 == null)
         {
            this.subAttributes = new Vector.<CCAttributeModule>();
         }
         else
         {
            this.subAttributes = param2;
         }
         this.singleAttributeSelection = param1;
         if(param4 == null)
         {
            this.range = new CCAbstractRangeModule();
         }
         else
         {
            this.range = param4;
         }
         this.toolTip = param5;
      }
      
      public static function get instance() : CCAttributeModule
      {
         return _instance || (_instance = new CCAttributeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7953;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CCAttributeModule = null;
         this.name = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.subAttributes.length > 0)
         {
            this.subAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CCAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.subAttributes.push(_loc4_);
            _loc2_++;
         }
         this.singleAttributeSelection = param1.readBoolean();
         this.range = CCAbstractRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.range)
         {
            this.range.read(param1);
         }
         this.toolTip = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CCAttributeModule = null;
         param1.writeShort(7953);
         param1.writeUTF(this.name);
         param1.writeShort(this.subAttributes.length);
         for each(_loc2_ in this.subAttributes)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.singleAttributeSelection);
         if(null != this.range)
         {
            this.range.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.toolTip);
      }
   }
}

