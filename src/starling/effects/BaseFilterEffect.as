/**
 *	Copyright (c) 2016 Devon O. Wolfgang
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

package starling.effects 
{

import starling.rendering.FilterEffect;
import starling.rendering.Program;
import starling.utils.RenderUtil;

/**
 * Base Filter effect for Starling Filters
 * @author Devon O.
 */
public class BaseFilterEffect extends FilterEffect
{
    
    protected var fragmentShader:String;
    protected var vertexShader:String;
    
    /** Create a new BaseFilter Effect */
    public function BaseFilterEffect() 
    {
        this.vertexShader = STD_VERTEX_SHADER;
        super();
    }
    
    /** Create Program */
    override protected function createProgram():Program 
    {
        createShaders();
        return Program.fromSource(this.vertexShader, this.fragmentShader);
    }
    
    /** Create Fragment and/or Vertex shaders */
    protected function createShaders():void
    {
        // Override to create shader programs
        this.fragmentShader = RenderUtil.createAGALTexOperation("oc", "v0", 0, this.texture);
    }
}

}