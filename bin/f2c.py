#!/usr/bin/env python

"""
f2c

A script for auto-building c-wrappers of Fortran 90 code.

TODO
----

  o index mangling - converting 1->n to 0->(n-1)

"""

import markupbase
import re

# regular expressions for finding key Fortran components: procedures (functions
# and subroutines) and for parsing arguments
interesting = re.compile('function|subroutine|type|class')
function_type = re.compile('.+(?=\sfunction)') # [XXX] also finds 'end's


class FortranParseError(Exception):
    """
    Exception raised for all parse errors.
    """
    def __init__(self, msg, position=(None,None)):
        assert msg
        self.msg = msg
        self.lineno = position[0]
        self.offset = position[1]

    def __str__(self):
        result = self.msg
        if self.lineno is not None:
            result = result + ", at line %d" % self.lineno
        if self.offser is not None:
            result = result + ", column %d" %(self.offset + 1)
        return result


class FortranParser(markupbase.ParserBase):
    """
    Find and store informatin on Fortran subroutines and functions.

    Usage:
        >>> p = FortranParser()
        >>> p.feed(data)
        ...
        >>> p.close()

    """
    def __init__(self):
        """
        Initialize and reset this instance of the parser.
        """
        self.reset()

    def reset(self):
        """
        Reset this instance. Loses all unprocessed data.
        """
        self.rawdata = ''
        self.lastprocedure = '???'
        self.interesting = interesting
        markupbase.ParserBase.reset(self)

    def feed(self, data):
        r"""
        Feed data to the parser.

        Call this as often as you want with as little or as much text as you
        want. (Text may include '\n'.)
        """
        self.rawdata = self.rawdata + data
        self.goahead(0)

    def close(self):
        """
        Handle and buffered data.
        """
        self.goahead(1)

    def error(self, message):
        raise FortranParseError(message, self.getpos())


    # Internal -- handle data as far as reasonable. May leave state and data to
    # be processed by a subsequent call. If 'end' is true, forse handling all
    # data as if folled by EOF marker.
    def goahead(self, end):
        rawdata = self.rawdata
        i = 0
        n = len(rawdata)

        # main loop: examine Fortran code
        while i < n:
            # look for a match on the start or end of a subroutine, function,
            # type, or class. If no matches are found, go to EOF.
            match = self.interesting.search(rawdata,i)
            if match:
                j = match.start()
                print "match found at character %d" % j
            else:
                j = n

            # temporary position update
            if i < j:
                i = self.updatepos(i,j)
            else:
                i = self.updatepos(i,i+1)
            if i == n: break

    def parse_function_header(self):
        pass

    def parse_subroutine_header(self):
        pass

    def parse_attributes(self):
        pass


class Argument(object):
    """
    Defines a Fortran 90 argument to a procedure.
    """
    def __init__(self):
        name = None
        type = None
        intent = None
        is_allocatable = None
        is_pointer = None
        is_target = None
        shape = None
        dimension = None


class Procedure(object):
    arguments = None

class Function(Procedure):
    type = None

class Subroutine(Procedure):
    pass

# class Type(object):
#     pass

# class Class(object):
#     pass



if __name__=='__main__':
    print('=== f2c.py Testing ===')
    # test an example
    f = open('examples/simple/simple.f90')
    s = f.read()
    f.close()

    # run the parser on the file string
    p = FortranParser()
    p.feed(s)
    p.close()

    print("...done.")
